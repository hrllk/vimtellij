# Markdown Fold Sidecar 영속성

상태: 현재 구현 기준 정리
작성일: 2026-08-19
대상: `lua/config/folding_sidecar.lua`, `lua/config/folding_anchor.lua`, `lua/plugins/editor/folding.lua`

## 요약

Markdown 본문에 fold marker를 넣지 않고, 문서 옆 sidecar JSON에 수동 fold 상태를 저장한다. sidecar는 실제 fold 상태가 변경될 때 생성하며, 문서를 열기만 한 경우에는 생성하지 않는다.

```text
Areas/PER-LOG-2026.md
Areas/.PER-LOG-2026.md.folds.json
```

일반 파일은 기존 `mkview/loadview`와 Neovim local view를 사용하고, Markdown은 sidecar를 source of truth로 사용한다.

## 목표와 제외 범위

- Markdown 본문을 수정하지 않고 fold 상태를 Git으로 공유한다.
- 문서에 줄이 추가·삭제되어도 text와 occurrence anchor로 fold를 복원한다.
- malformed JSON이나 일부 유효하지 않은 anchor가 문서 열기를 막지 않게 한다.
- sidecar 계산 로직과 Neovim 이벤트 adapter를 분리한다.

다음은 이 범위에 포함하지 않는다.

- 독립 플러그인 저장소 및 public `setup()` API
- sidecar schema migration
- Markdown 외 filetype
- `zC`, `zO`, `zA`, `zR`, `zM` 영속화
- heading parser, AST 기반 identity
- sidecar inspect/reset 명령
- 자동 Git add/commit/push

## Sidecar schema

현재 schema는 version 2이며 `folds`는 배열이다.

```json
{
  "version": 2,
  "source": "PER-LOG-2026.md",
  "folds": [
    {
      "start": { "text": "## 2026-08-05", "occurrence": 1 },
      "end": { "text": "내용", "occurrence": 1 },
      "state": "closed"
    }
  ]
}
```

- `version`: 현재 `2`만 읽는다.
- `source`: 문서 basename만 저장한다.
- `folds`: 닫힌 fold entry 배열이다.
- `state`: 현재는 `closed`만 저장한다.
- JSON은 같은 디렉터리의 임시 파일에 쓴 뒤 rename한다.
- source/version/schema가 맞지 않으면 restore를 건너뛴다.

## Anchor 규칙

`lua/config/folding_anchor.lua`가 순수 Lua 값만 사용해 계산한다.

- text는 trim 후 연속 whitespace를 한 칸으로 정규화한다.
- 빈 줄과 Markdown separator line은 occurrence 계산에서 제외한다.
- occurrence는 문서 처음부터 센 동일 정규화 text의 1-based 발생 순번이다.
- fold 범위의 첫 번째·마지막 non-ignorable line을 start/end anchor로 저장한다.
- persisted anchor를 현재 문서에서 다시 찾아 실제 line range를 계산한다.
- anchor가 없거나 start가 end보다 뒤면 해당 entry만 건너뛴다.
- nested fold는 허용한다.
- 두 range가 교차하지만 서로 완전히 포함하지 않으면 partial overlap으로 판단한다.

## 동작 흐름

```text
Markdown buffer
    │ zf / zo / BufWinEnter
    ▼
folding.lua
    │ keymap·autocmd·ufo 연결
    ▼
folding_sidecar.lua
    │ buffer/path/JSON/file I/O
    ▼
folding_anchor.lua
    │ normalize/capture/resolve/overlap
    ▼
.<filename>.folds.json
```

### `zf`

Visual-mode `zf`가 native fold를 만든 뒤 실제로 닫힌 것을 확인하면 sidecar entry를 upsert한다. empty 또는 ignorable-only range는 저장하지 않는다.

### `zo`

`vim.on_key`가 `z` 입력 시 현재 fold range를 기억하고, 다음 `o` 입력 후 sidecar에서 해당 entry를 제거하도록 예약한다. 복원 중에는 저장을 억제한다.

### `BufWinEnter`

Markdown sidecar가 존재할 때만 읽고, 유효한 anchor를 실제 fold로 적용한다. 일부 entry가 없어도 나머지 entry 복원을 계속한다.

### 일반 파일

Markdown이 아닌 파일은 기존 `mkview/loadview`와 `viewoptions=folds`를 사용한다. Markdown에는 local view와 sidecar를 동시에 적용하지 않는다.

## 실패 처리

| 경로 | 실패 | 동작 |
|---|---|---|
| read | 파일 없음 | restore하지 않고 계속 진행 |
| read | malformed JSON/version/source 불일치 | debug 알림 후 무시 |
| capture | 빈 범위 또는 separator-only 범위 | entry를 만들지 않음 |
| resolve | anchor 없음 또는 잘못된 range | 해당 entry만 건너뜀 |
| upsert | partial overlap | 충돌 entry를 저장하지 않음 |
| write | write/rename 실패 | 임시 파일을 삭제하고 `false` 반환 |
| restore | 일부 overlap | 충돌 entry를 건너뛰고 나머지 복원 |
| scheduled callback | buffer/window 무효화 | sidecar를 변경하지 않음 |

## 검증

외부 테스트 프레임워크 없이 Neovim headless runner를 사용한다.

```sh
nvim --headless -u NONE -l tests/folding_anchor_spec.lua
nvim --headless -u NONE -l tests/folding_sidecar_spec.lua
nvim --headless -u NONE -l tests/folding_adapter_smoke.lua
./scripts/check
```

검증 범위:

- normalize, ignorable line, occurrence, capture, resolve, overlap
- version 2 JSON read/write와 malformed/source/version 오류
- document edit 후 anchor 기반 range 복원
- nested/partial-overlap 처리
- `zf`/`zo`/`BufWinEnter` adapter 연결
- 일반 파일 local view 회귀

## 장기 방향

현재 작업은 sidecar 동작과 순수 계산 경계를 안정화하는 단계다. 다음 조건을 만족한 뒤에만 독립 `markdown-folds.nvim` 추출을 검토한다.

- sidecar schema와 복원 정책이 안정됨
- headless 테스트가 설정 저장소 밖에서도 재사용 가능함
- 여러 Neovim 설정에서 사용할 실제 수요가 있음
