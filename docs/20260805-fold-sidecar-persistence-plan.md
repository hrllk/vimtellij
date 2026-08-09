# Markdown Fold Sidecar 영속성 계획

상태: 최소 구현 완료, 후속 범위 보류  
작성일: 2026-08-05  
대상: `lua/plugins/editor/folding.lua`

## 요약

Markdown 본문에 fold marker를 넣지 않고, 문서 옆의 sidecar JSON 파일에 폴딩
상태를 저장한다. sidecar는 지연 생성한다. Markdown을 열기만 한 문서에는
파일을 만들지 않고, 실제로 fold/expand 동작이 발생한 시점부터 생성한다.

```text
Areas/PER-LOG-2026.md
Areas/.PER-LOG-2026.md.folds.json
```

`.PER-LOG-2026.md.md.folds.json`처럼 `.md`가 중복되는 이름은 사용하지 않는다.

## 해결하려는 문제

현재 설정은 `foldmethod=manual`을 사용한다. `nvim-ufo`가 fold 표시와 미리보기를
담당하고, `mkview/loadview`가 각 PC의 Neovim 로컬 상태 디렉터리에 폴딩 상태를
저장한다. 따라서 같은 PC에서는 재시작 후 복원되지만 Git으로 다른 PC에 전달되지
않는다.

`foldmethod=marker`는 공유가 가능하지만 Markdown 본문에 fold 문법이 들어가고,
preview·diff·다른 Markdown 도구에 영향을 줄 수 있다. sidecar 방식은 본문과
편집기 상태를 분리하면서 Git 공유를 가능하게 한다.

## 목표

- 선택한 Markdown 문서의 fold 열림/닫힘 상태를 Git으로 공유한다.
- Markdown 본문은 변경하지 않는다.
- 폴딩을 사용하지 않은 문서에는 sidecar를 만들지 않는다.
- 기존 sidecar가 있으면 문서 열 때 복원한다.
- `zf`로 생성한 fold 범위의 첫 heading과 `zo`로 펼친 상태를 sidecar에 upsert한다.
- Markdown 이외 파일은 기존 로컬 view 방식을 유지한다.
- 잘못된 sidecar가 문서 열기를 방해하지 않게 한다.
- 사람이 읽고 Git diff로 확인할 수 있는 버전 있는 JSON 형식을 사용한다.

## 범위 제외

- 자동 `git add`, commit, pull, push
- 커서 위치, 창 배치, preview 상태 공유
- 안정적인 식별자가 없는 임의 manual fold 지원
- `nvim-ufo` provider 또는 preview UI 교체
- `BufRead`, `BufEnter`, `BufWinEnter`만으로 sidecar 생성
- `foldmethod=marker`로 Markdown 본문 변경
- 코드·JSON·YAML 등 다른 filetype의 sidecar 지원

## 권장 설계

### 1. Markdown 수동 fold와 식별자

`foldmethod=manual`과 현재 `nvim-ufo`의 수동 fold 표시 동작을 유지한다. Markdown
전용 provider 전환은 하지 않는다. 다른 filetype도 현재 manual/local-view 동작을
유지한다.

상태는 줄 번호가 아니라 Markdown heading의 계층 경로로 식별한다.

```text
"h1|Projects#1/h2|Personal#1"
"h1|Projects#1/h2|Personal#2"
```

이 방식은 heading 위에 줄을 추가해도 줄 번호보다 안정적이다. 같은 이름의
heading은 부모 경로와 발생 순번으로 구분한다. heading 이름을 바꾸거나 다른
부모 아래로 이동하면 기존 상태는 무시하고 새 상태로 시작한다.

### 2. Sidecar JSON 형식

```json
{
  "version": 1,
  "source": "PER-LOG-2026.md",
  "folds": {
    "h2|2026-08-05|1": "closed"
  }
}
```

규칙:

- `version`은 필수이며 향후 migration에 사용한다.
- `source`는 문서의 basename만 저장하고 PC별 절대 경로는 저장하지 않는다.
- `folds`에는 인식된 Markdown fold만 저장한다.
- sidecar에는 `closed` 상태만 저장한다. key가 없으면 `open`으로 간주한다.
- 알 수 없는 key는 읽을 때 무시하고, 다음 정상 upsert 때 제거한다.
- JSON은 deterministic encoding으로 작성해 Git diff를 안정적으로 유지한다.
- 파일은 같은 디렉터리의 임시 파일에 먼저 쓴 뒤 rename한다. 중단 상황에서
  기존의 정상 JSON이 잘린 상태로 남지 않게 한다.

### 3. 지연 생성 lifecycle

```text
Markdown 열기
  ├─ sidecar 있음: 읽고 검증한 뒤 fold 준비 후 복원
  └─ sidecar 없음: 아무것도 만들지 않음

fold/expand 동작으로 상태 변경
  ├─ sidecar 있음: 닫힌 fold는 추가, 펼친 fold는 key 제거
  └─ sidecar 없음: 이 시점에 생성 후 현재 상태 저장

창 나가기
  ├─ sidecar 활성화됨: 최신 상태 upsert
  └─ 한 번도 활성화되지 않음: 아무것도 하지 않음
```

sidecar 복원 중에는 저장을 억제한다. 그렇지 않으면 복원 과정에서 발생한
이벤트가 불완전한 상태를 즉시 다시 저장할 수 있다.

자동 fold 갱신이나 복원 과정에서 상태가 바뀌어도 sidecar가 생성되지 않도록,
최초 생성은 `vim.on_key`로 감지한 명시적 `zf` 입력 뒤에만 허용한다.

### 4. 이벤트와 명령 처리

sidecar가 없는 문서는 `vim.on_key`로 감지한 사용자의 명시적 `zf` 입력 뒤 첫 번째 실제 fold
생성 시 sidecar를 활성화한다. `zf` 범위 안의 첫 Markdown heading key를 찾고,
없으면 범위를 포함하는 가장 가까운 상위 heading key를 `closed`로 저장한다.
heading이 문서에 전혀 없으면 화면에서는 fold를 만들되
교차 PC 복원을 위해 sidecar에는 저장하지 않는다.

`vim.on_key`는 native `zf`/`zo`의 입력 시퀀스를 관찰한다. native 명령과 motion이
끝난 뒤 한 번 지연해 fold 상태를 snapshot한다. `zf`는 범위 안 첫 heading만
sidecar에 추가하고, `zo`는 기존 sidecar의 해당 key만 제거한다.
Neovim의 표준 `FoldClosed`/`FoldOpened` 이벤트에는 의존하지 않는다.

wrapper는 native 명령을 먼저 실행하고, 이후 debounced snapshot을 예약한다.
snapshot은 buffer-local로 실행하며 help, prompt, quickfix, unnamed, non-Markdown
버퍼에서는 실행하지 않는다.

명령별 최소 범위:

| 명령 | 화면 동작 | sidecar 동작 |
|---|---|---|
| `zf` | 현재 범위에 수동 fold 생성 | 범위 안 첫 heading 또는 상위 heading key 추가 |
| `zo` | 현재 fold 펼치기 | 현재 heading key를 제거 |

따라서 `zo` 실행 시 해당 key가 JSON에서 제거되는 것이 정상이다. JSON에는
`open` 값을 남기지 않으므로 diff도 “닫힌 상태가 해제됨”만 표현한다.

### 5. 복원 시점

`BufWinEnter`에서는 sidecar가 실제로 존재할 때만 읽는다. 기존 수동 fold가
준비된 뒤 한 번만 복원하며, 복원 과정에서 sidecar를 다시 쓰지 않는다.

존재하지 않는 heading은 무시한다. heading은 있지만 fold range를 만들 수 없는
경우 해당 항목만 열린 상태로 두고 나머지 복원을 계속한다.

Markdown 버퍼에는 기존 `mkview/loadview`를 함께 적용하지 않는다. 두 저장소가
동시에 작동하면 PC마다 오래된 local view와 sidecar의 적용 순서가 달라질 수
있다. Markdown은 sidecar를 단일 source of truth로 사용하고, local view는
Markdown 이외 파일에만 유지한다.

## 데이터 흐름

```text
Markdown buffer
    │ heading + 현재 fold 상태
    ▼
Fold 상태 adapter
    │ 정규화된 heading key
    ▼
Sidecar repository
    │ 검증 / merge / deterministic encode
    ▼
같은 경로의 .<filename>.folds.json
    │
    └── 사용자가 선택해 Git add/commit
```

## 실패 및 복구 표

| 코드 경로 | 실패 상황 | 복구 여부 | 사용자에게 보이는 결과 | 테스트 |
|---|---|---:|---|---:|
| sidecar 읽기 | 파일 없음 | 예 | 아무 변화 없음 | 예 |
| sidecar 읽기 | JSON/schema 오류 | 예 | debug 알림 후 문서 정상 열림 | 예 |
| fold 복원 | ufo 준비 전 실행 | 예 | 한 번 재시도, 잠시 열려 있을 수 있음 | 예 |
| snapshot | heading 없음 | 예 | 실제 변경 전에는 sidecar 미생성 | 예 |
| snapshot | 중복 heading | 예 | 계층 경로와 순번으로 구분 | 예 |
| sidecar 쓰기 | 권한/디스크 부족 | 예 | 편집은 계속되고 원인 알림 | 예 |
| sidecar 쓰기 | 쓰기 중 중단 | 예 | 이전 정상 JSON 유지 | 예 |
| key observer | 복원 중 재진입 | 예 | 저장 억제 | 예 |
| local view | Markdown sidecar와 충돌 | 예 | Markdown은 sidecar만 사용 | 예 |

## 구현 단계

### 1단계: 테스트 가능한 sidecar adapter

- sidecar 경로, schema 검증, heading key 생성, merge/upsert, deterministic
  encoding을 순수 Lua helper로 분리한다.
- 파일 I/O를 작은 함수 뒤에 두어 malformed JSON과 쓰기 실패를 독립적으로
  테스트한다.
- buffer-local 활성화 flag와 복원 guard를 추가한다.

### 2단계: Markdown lifecycle 연결

- 현재 `foldmethod=manual`과 `nvim-ufo` 수동 fold 표시를 유지한다.
- 기존 sidecar만 읽고, 없는 sidecar는 만들지 않는다.
- 현재 수동 fold가 준비된 뒤 인식된 heading 상태만 복원한다.
- `vim.on_key` 기반 `zf`/`zo` 입력 감지와 복원 guard를 연결한다.
- 변경 시 debounce된 upsert를 실행하고 `BufWinLeave`에서도 최신 상태를 저장한다.
- Markdown은 기존 local view 저장/복원을 제외한다.

### 3단계: 실제 editor 검증

- sidecar가 없는 Markdown을 열고 아무 fold도 하지 않았을 때 파일이 생기지 않는지
  확인한다.
- 첫 `zf` 동작에서 heading 기반 sidecar가 한 번만 생성되는지 확인한다.
- `zo`로 펼친 heading의 key가 sidecar에서 제거되는지 확인한다.
- heading이 아닌 범위의 `zf`는 sidecar를 만들지 않는지 확인한다.
- Neovim 재시작 후 다른 PC에서 pull한 상태가 복원되는지 확인한다.
- heading 위에 줄을 추가해도 상태가 heading을 따라가는지 확인한다.
- heading rename, 중복 heading, malformed JSON, 읽기 전용 디렉터리, 쓰기 실패,
  중단된 atomic write를 확인한다.
- non-Markdown 파일의 기존 local view 동작이 유지되는지 확인한다.

## 테스트 흐름

```text
열기
 ├─ sidecar 없음 ───────▶ 파일 미생성 [unit + headless integration]
 ├─ 정상 sidecar ───────▶ fold 복원 [headless integration]
 ├─ malformed sidecar ──▶ 안전한 fallback [unit]
 └─ fold 준비 지연 ─────▶ 제한된 재시도 [headless integration]

fold 동작
 ├─ 첫 zf 변경 ──────────▶ 지연 생성 [headless integration]
 ├─ zo 확장 ─────────────▶ 해당 closed key 제거 [integration]
 ├─ heading 없는 zf ─────▶ sidecar 미생성 [integration]
 ├─ 기존 sidecar 변경 ──▶ debounced upsert [unit + integration]
 ├─ 반복 key 감지 ──────▶ 한 번의 deterministic write [integration]
 └─ 복원 과정 ──────────▶ 저장 억제 [integration]

식별자
 ├─ heading 위 줄 추가 ─▶ 기존 상태 유지 [unit]
 ├─ 중복 heading 이동 ──▶ 부모 경로 key 검증 [unit]
 └─ heading 이름 변경 ──▶ 오래된 key 무시 [unit]
```

현재 저장소에는 전용 Lua 테스트 프레임워크가 없다. 따라서 순수 adapter를
분리하고 작은 headless Lua 테스트 harness를 추가하는 방향이 적절하다.
`scripts/check`는 필수 설정 smoke test로 유지하고, 실제 두 PC Git round trip은
최종 acceptance test로 둔다.

## Acceptance criteria

- fold를 사용하지 않은 Markdown에는 sidecar가 생성되지 않는다.
- 첫 번째 명시적 `zf` 상태 변경 시 정확히 하나의 sidecar가 생성된다.
- `zf` 범위 안에 heading이 있으면 fold 상태가 교차 PC 복원된다.
- 문서에 heading이 전혀 없는 `zf`는 화면에서만 동작하고 sidecar에는 저장되지 않는다.
- 두 번째 PC가 두 파일을 pull하면 선택한 닫힌 section이 복원된다.
- Markdown 본문과 preview 결과는 persistence 때문에 변하지 않는다.
- heading 위의 줄 추가가 line-number 기반 상태 오류를 만들지 않는다.
- 잘못된 sidecar가 문서 열기를 막지 않는다.
- 실패한 쓰기가 기존 정상 sidecar를 truncate하지 않는다.
- `scripts/check`가 통과한다.
- schema, 식별자, 지연 생성, expand 시 key 제거, version 거부, 쓰기 실패
  테스트가 존재한다.

## 결정 사항과 남은 질문

### 결정 사항

- Markdown marker 대신 sidecar를 사용한다.
- 실제 fold 상태 변경 후에만 sidecar를 지연 생성한다.
- 파일명은 `.PER-LOG-2026.md.folds.json`으로 한다.
- 공유 persistence는 Markdown에만 적용한다.
- line number가 아닌 heading 계층 경로를 사용한다.
- Markdown은 local view가 아닌 sidecar를 source of truth로 사용한다.
- JSON 쓰기는 임시 파일 후 rename하는 atomic 방식으로 한다.
- sidecar가 없는 문서의 최초 활성화는 명시적 `zf`로만 한다.
- `zo`는 해당 heading의 `closed` key를 제거한다.
- 마우스 클릭만으로는 sidecar를 최초 생성하지 않는다.

### 보류하지 않는 구현 판단

- sidecar는 파일 탐색기에서 기본 숨김 처리한다. 상태 확인은 `:FoldStateInspect`
  또는 숨김 파일 표시 설정으로 한다.

## 이미 존재하는 코드

- `lua/plugins/editor/folding.lua`: nvim-ufo, fold text, highlight, cursorline,
  local view persistence를 이미 설정한다.
- `vim.opt.viewoptions:append("folds")`: local fold 상태 저장을 이미 활성화한다.
- `vim.opt.viewdir`: Neovim state 아래에 local view 저장 위치를 이미 지정한다.
- `scripts/check`: Lua syntax와 전체 Neovim 설정 load를 검증한다.

## 12개월 이상적인 상태와의 차이

장기적으로는 filetype별 fold 상태를 공통 서비스처럼 관리하고, editor에
종속되지 않는 안정적인 문서 구조 식별자와 conflict 도구를 갖는 것이 이상적이다.
이번 계획은 그 첫 단계로 Markdown만 대상으로 heading 기반 Git 공유를 제공한다.
Migration, conflict UI, 다른 filetype 지원은 숨은 요구사항이 아니라 이후 확장으로
남긴다.

## Architecture 검토 결과

```text
BufWinEnter ─▶ sidecar 있음? ─예─▶ JSON 검증 ─▶ ufo fold 대기 ─▶ 상태 복원
      │              │
      아니오         오류
      │              └────────────▶ debug 알림, 문서 열기 계속
      ▼
파일 생성 안 함

vim.on_key: zf/zo 입력 감지
      ▼
현재 heading snapshot ─▶ 변경 없음 ─▶ 쓰기 안 함
      │
      변경 있음
      ▼
deterministic encode ─▶ 임시 파일 ─▶ rename ─▶ sidecar
```

주요 위험은 JSON보다 사용자 동작과 수동 fold 갱신을 구분하는 부분이다. 자동
fold 갱신만으로 sidecar가 생기지 않도록 명시적 keymap, baseline 비교, 복원
guard, debounce를 함께 사용한다.

## CEO 관점 검토

이 계획은 여러 PC에서 같은 폴딩 상태를 공유하려는 문제를 Markdown 본문 오염
없이 해결한다. 다만 fold 상태가 개인 UI 취향일 수도 있으므로, sidecar를 모든
문서에 강제로 만들지 않고 실제 사용 문서에만 지연 생성하는 범위가 적절하다.

| 대안 | 장점 | 비용 | 결정 |
|---|---|---|---|
| local view 파일을 Git 추적 | 기존 기능 재사용 | PC 경로·줄 번호·view 잡음 | 제외 |
| Markdown marker | native하고 이식 가능 | 본문·preview 오염 | 제외 |
| Treesitter만 사용 | 문서가 깨끗함 | `zf` 수동 fold와 동작 모델이 다름 | 제외 |
| heading sidecar | 본문 변경 없이 공유 | custom 코드와 merge 충돌 | 선택 |

## Engineering 관점 검토

- Markdown의 local view와 sidecar를 동시에 사용하면 PC별 적용 순서가 달라지는
  충돌이 있으므로 Markdown local view를 제외해야 한다.
- 표준 `FoldClosed`/`FoldOpened` autocmd 이벤트가 없으므로, sidecar 변경은
  명시적 `zf`/`zo` 입력 감지 후 snapshot에서만 수행해야 한다.
- heading 식별자는 전역 발생 순번이 아니라 부모 경로와 순번을 포함해야 한다.
- JSON은 직접 덮어쓰지 말고 같은 디렉터리 임시 파일 후 rename해야 한다.
- 기존 저장소에는 전용 테스트 프레임워크가 없으므로 pure adapter와 headless
  integration을 분리해야 한다.

## DX 관점 검토 — 후속 범위

아래 명령·탐색기 UX는 이번 `zf`/`zo` MVP의 구현 범위에서 제외하고 후속으로
남긴다.

| 항목 | 점수 | 이유 |
|---|---:|---|
| 첫 사용 | 9/10 | 설정 없이 fold 전에는 파일이 생기지 않음 |
| 발견 가능성 | 8/10 | 문서 옆의 읽기 쉬운 이름과 JSON |
| 오류 복구 | 8/10 | 잘못된 상태가 편집을 막지 않음 |
| Git workflow | 8/10 | 명시적 untracked 파일과 deterministic diff |
| PC 간 결과 | 8/10 | 안정적인 heading은 상태를 따라감 |
| 초기화 방법 | 7/10 | sidecar 삭제로 초기화 가능, 전용 명령은 후속 |

사용자 흐름:

```text
Markdown 열기 → 새 파일 없음 → section 접기 → sidecar 생성 →
Git diff 확인 → commit → 다른 PC에서 pull → fold 복원
```

첫 생성 시에는 정확한 sidecar 경로와 초기화 방법을 한 번만 알림으로 보여주는
것이 좋다. 예시는 다음과 같다.

```text
Fold state sidecar created:
Areas/.PER-LOG-2026.md.folds.json
Reset with :FoldStateReset
```

같은 문서에서는 반복 알림하지 않는다. Git staging은 자동으로 하지 않는다.

`:FoldStateInspect` 명령으로 현재 sidecar 경로와 닫힌 section 목록을 확인할 수
있게 한다. 이 명령은 파일을 수정하지 않고 현재 문서의 persistence 상태만
보여준다.

Snacks 파일 탐색기에서는 `.filename.md.folds.json` sidecar를 기본적으로 숨긴다.
sidecar를 직접 확인해야 할 때는 `:FoldStateInspect`나 숨김 파일 표시 설정을
사용할 수 있어야 한다.

`:FoldStateReload`는 현재 버퍼의 Markdown 본문을 다시 읽지 않고 sidecar만 다시
읽어 fold 상태를 적용한다. 따라서 Git pull 후 저장하지 않은 본문 편집 내용을
잃지 않고 현재 버퍼의 표시 상태만 갱신할 수 있다.

reload 시에는 현재 버퍼의 heading 구조를 기준으로 일치하는 fold만 적용한다.
sidecar에만 존재하는 key는 무시하고, 이 동작만으로 본문이나 sidecar를 즉시
변경하지 않는다.

## 구현 작업

- [x] sidecar 이름과 schema helper 정의
- [x] Markdown heading 계층 경로와 중복 heading 처리
- [x] 지연 생성, restore guard, key 감지·fold 상태 fallback sync, atomic write 구현
- [x] Markdown local view 저장/복원 제외
- [x] `zf` 시작 범위를 heading key로 변환하는 adapter 구현
- [x] `vim.on_key` 기반 `zf`/`zo` 감지와 복원 guard 구현
- [x] adapter 및 실제 설정 smoke test
- [ ] 전용 unit/integration 테스트 파일 추가
- [x] 설정 syntax 및 Neovim config load 검증
- [ ] 두 PC Git round trip 수동 검증

## CEO 선택 범위

선택한 접근법: `zf` 기반 heading fold + `zo` 기반 sidecar 정리
선택한 리뷰 모드: SELECTIVE EXPANSION

구현 범위:

- `zf`로 생성한 fold의 시작 heading을 sidecar key로 저장
- `zo`로 펼친 heading의 closed key 제거
- heading 없는 임의 범위는 sidecar 영속성 대상에서 제외
- sidecar는 첫 번째 실제 `zf` 상태 변경 시에만 지연 생성
- 기존 sidecar는 수동 fold 준비 후 복원

후속 범위:

- `zC`, `zO`, `zA`, `zR`, `zM` 범위 명령 연동
- `:FoldStateReset`, `:FoldStateInspect`, `:FoldStateReload`
- 최초 생성 알림과 Snacks 탐색기 숨김

## Decision Audit Trail

| # | 결정 | 원칙 | 이유 |
|---:|---|---|---|
| 1 | marker 대신 sidecar | 완전성 | Markdown 의미를 바꾸지 않고 상태 공유 |
| 2 | sidecar 지연 생성 | 사용자 결과 | 사용하지 않은 문서에 파일을 만들지 않음 |
| 3 | heading 계층 식별 | 명시성 | 줄 번호보다 안정적이고 사람이 확인 가능 |
| 4 | Markdown local view 제외 | 실용성 | 두 상태 저장소의 충돌 방지 |
| 5 | atomic write | 완전성 | 중단 시 정상 상태 보존 |
| 6 | `zf` 범위의 첫 heading을 identity로 사용 | 명시성 | 임의 줄 범위보다 PC 간 복원 안정성이 높음 |
| 7 | heading 없는 문서의 `zf`는 영속화하지 않음 | 실용성 | 줄 번호 기반 오복원을 방지 |
| 8 | `zo` 시 closed key 제거 | 명시성 | 화면 상태와 JSON을 일치시킴 |
| 9 | 명시적 `zf` 입력만 최초 활성화 | 실용성 | 자동/마우스 이벤트로 인한 오생성 방지 |
| 10 | 범위 명령·관리 명령은 후속 | 비례성 | 실제 요구사항 `zf`/`zo`에 집중 |

## Autoplan 상태

CEO: 검토 완료  
Design: UI 범위가 아니므로 생략  
Eng: 검토 완료  
DX: 별도 리뷰 필요  
구현 전 최종 승인: 대기 중

## Eng Review 결과

### 범위

구현 파일은 `folding.lua`, sidecar adapter, 순수 Lua 테스트, headless 통합
테스트로 제한한다. provider 교체, marker, 범위 fold 명령, 관리 명령, explorer
변경은 범위 밖이다.

### 아키텍처

```text
native zf/zo 입력
      │ vim.on_key 관찰
      ▼
짧은 지연 후 현재 manual fold snapshot
      │ Markdown + heading 시작 여부 확인
      ▼
sidecar adapter ─▶ schema/identity/merge ─▶ atomic JSON write
      ▲
      │ sidecar read + manual fold 재생성
Markdown BufWinEnter
```

`vim.on_key`는 native `zf` operator와 motion을 가로채지 않고 관찰만 한다. 입력
후 snapshot 시점에 실제 fold 상태와 heading identity를 확인한다. 복원 중에는
guard를 세워 snapshot write를 억제한다.

### 코드 품질 및 성능

- adapter는 Neovim window state와 분리해 순수 함수 중심으로 작성한다.
- JSON key는 정렬된 배열 또는 명시적 정렬 encode를 사용해 diff를 결정적으로 만든다.
- 저장은 debounce하고, 동일 snapshot은 write하지 않는다.
- atomic write는 sidecar와 같은 디렉터리의 임시 파일과 `rename`을 사용한다.
- `vim.on_key` callback은 키 상태만 갱신하고 JSON I/O는 예약 callback에서 수행한다.
- 한 문서의 heading 수에 선형으로 동작하며, sidecar 전체를 매 키 입력마다 쓰지
  않도록 변경 snapshot 비교를 둔다.

### 테스트 검토

테스트 계획은 다음 artifact에 기록했다.

`/Users/hrk/.gstack/projects/hrllk-vimtellij/hrk-main-eng-review-test-plan-20260805-232117.md`

작업 목록은 다음 JSONL artifact에 기록했다.

`/Users/hrk/.gstack/projects/hrllk-vimtellij/tasks-eng-review-20260805-232117.jsonl`

핵심 회귀는 native `zf` motion 보존, heading 없는 `zf`의 sidecar 미생성,
`zo`의 key 제거, Markdown local view 제외, malformed JSON·atomic write 실패다.

## GSTACK REVIEW REPORT

| Review | Trigger | 목적 | Runs | Status | Findings |
|---|---|---|---:|---|---|
| CEO Review | `/plan-ceo-review` | 범위와 전략 | 1 | COMPLETE | 초기 범위 검토 후 `zf`/`zo` 최소 범위로 재조정 |
| Codex Review | `codex exec` | 독립 의견 | 1 | COMPLETE | global manual/local view 충돌 위험 확인 |
| Eng Review | `/plan-eng-review` | 구조와 테스트 | 1 | COMPLETE | `manual fold + vim.on_key + sidecar` 확정 |
| Design Review | `/plan-design-review` | UI/UX | 0 | SKIPPED | UI 범위 아님 |
| DX Review | `/plan-devex-review` | 개발자 경험 | 0 | PENDING | 명령·sidecar workflow 검토 필요 |

- **CODEX:** 현재 구현은 전역 `manual` folding과 무조건적인 `mkview/loadview`를
  사용한다. Markdown sidecar를 도입할 때 Markdown local view를 제외해야 한다.
- **ENG:** native `zf`를 단순 keymap으로 대체하면 motion이 깨지므로 `vim.on_key`
  관찰 방식으로 확정했다. Neovim에 `FoldClosed`/`FoldOpened` 표준 autocmd가
  없으므로 해당 이벤트 의존을 제거했다.
- **VERDICT:** CEO review CLEARED. Eng review COMPLETE. 구현 가능 상태다.

**UNRESOLVED DECISIONS:**
- 구현 시 `vim.on_key` 감지 후 지연 시간은 headless 통합 테스트로 확정한다.
