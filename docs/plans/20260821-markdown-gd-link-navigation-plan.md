# Markdown 전용 링크 이동 구조화 계획

상태: CEO PASS, spec 작성 대기
작성일: 2026-08-21

## 목표

전역 `gd`를 변경하지 않고 Markdown 버퍼에서만 링크 이동을 지원한다. Java,
Go, Lua, TypeScript의 기존 LSP definition 동작과 키맵은 그대로 보존한다.

## 현재 상태

- `lua/config/keymaps.lua`의 전역 `gd`는 `vim.lsp.buf.definition()`을 호출한다.
- `lua/plugins/lsp/lspconfig.lua`에서 `marksman`을 Markdown LSP로 활성화한다.
- Marksman은 Markdown definition을 제공하지만, 외부 YAML/임의 파일 링크는
  definition 결과가 없을 수 있다.
- 이전 fallback 구현은 전역 keymaps 파일에 Markdown 파싱과 파일 열기 로직을
  함께 두어 Java 등 다른 언어의 전역 매핑과 관심사가 섞였다.
- `lua/plugins/lsp/mason-lspconfig.lua`는 `gopls`, `lua_ls`, `marksman`,
  `ts_ls`만 자동 설치 대상으로 둔다. `jdtls`는 `nvim-jdtls`와
  `ftplugin/java.lua`가 직접 관리하므로 이 목록에 넣지 않는다.

## 범위

포함:

1. Markdown 전용 진입점(`ftplugin/markdown.lua` 또는 전용 모듈) 설계
2. 내부 Markdown 링크와 외부 파일 링크의 동작 계약 정의
3. Marksman 미연결, definition 미응답, 잘못된 링크의 사용자-visible 동작 정의
4. Java/Go/Lua/TypeScript 전역 `gd` 회귀 검증
5. headless Neovim 기반 테스트와 `scripts/check` 검증

제외:

- 전역 Java/Go/Lua/TypeScript LSP 키맵 변경
- Markdown 렌더링 또는 preview 기능 변경
- 새로운 외부 플러그인 도입
- 링크 대상 파일의 내용이나 경로 정리

## 검토할 구현안

### A. Markdown ftplugin에 buffer-local `gd`만 추가

Markdown 파일이 열릴 때만 `gd`를 덮어쓰고, 링크 해석 로직은 별도 모듈에
둔다. 가장 작은 변경으로 전역 언어 서버 키맵과 격리된다.

### B. 별도 Markdown 링크 모듈 + ftplugin 얇은 어댑터

링크 파싱, LSP 응답, 파일 fallback을 `lua/config/markdown_links.lua`에
두고 `ftplugin/markdown.lua`는 buffer-local 연결만 담당한다. 테스트와 향후
`gx`/command 연동에는 유리하지만 파일 수와 추상화가 늘어난다.

### C. 키맵 없이 `gx`/`gf`와 Marksman 기본 definition만 사용

Neovim과 LSP의 기존 기능만 사용한다. 설정은 가장 단순하지만 현재 요구사항인
`gd` 통합과 링크 텍스트 위에서의 외부 파일 이동을 모두 보장하지 못한다.

## 결정 게이트

1. CEO 리뷰에서 구현 방향과 범위를 확정한다.
2. CEO 리뷰가 통과하면 이 계획을 backlog-ready spec으로 전환한다.
3. spec 확정 후 Eng 리뷰에서 파일 경계, 실패 경로, 테스트 범위를 확정한다.
4. Eng 리뷰가 통과하기 전에는 구현을 시작하지 않는다.

## CEO 리뷰 결정

- 선택안: B. `lua/config/markdown_links.lua`와 `ftplugin/markdown.lua` 어댑터
- 이유: 전역 `gd`를 보존하면서 링크 해석·fallback 로직을 테스트 가능한
  Markdown 전용 경계로 격리한다.
- 범위 모드: HOLD SCOPE
- 등록 시점: `FileType markdown` 시점에 buffer-local `gd`를 등록하고, 링크
  실행 시점에 Marksman definition을 조회한다.
- 외부 링크: 절대 경로·현재 Markdown 파일 기준 상대 경로·`~` 경로를 지원한다.
- 실행 순서: Marksman definition 우선, 결과가 없을 때만 파일 fallback을 시도한다.
- 실패 처리: 대상이 없거나 지원하지 않는 링크만 짧은 `vim.notify`로 알린다.
- 링크 경계: 일반/reference/wiki 링크 의미는 Marksman에 맡기고, fallback은
  파일 경로로 안전하게 해석 가능한 링크에 한정한다.
- 테스트: resolver 단위 테스트, Markdown buffer-local `gd` headless smoke test,
  `scripts/check`를 실행한다.
- 경로 기준: 상대 경로는 현재 Markdown 파일의 디렉터리를 기준으로 해석하며,
  셸을 실행하지 않고 Lua/Neovim 경로 API로 확장한다.

## Implementation Tasks

CEO 리뷰에서 확정된 구현 작업입니다.

- [ ] **T1 (P1)** — Markdown 링크 resolver 모듈 구현
  - Files: `lua/config/markdown_links.lua`
  - Verify: 내부 링크, 외부 절대/상대/`~` 경로, definition 없음, 잘못된 경로 테스트
- [ ] **T2 (P1)** — Markdown 전용 buffer-local `gd` 어댑터 구현
  - Files: `ftplugin/markdown.lua`
  - Verify: Markdown에서만 매핑되고 `lua/config/keymaps.lua`는 변경되지 않음
- [ ] **T3 (P1)** — headless resolver 및 키맵 smoke test 추가
  - Files: `tests/`, `scripts/check` 연계 위치
  - Verify: Marksman 미연결/무응답에서도 Neovim 시작과 fallback이 안전함
- [ ] **T4 (P2)** — 구현 후 Java/Go/Lua/TypeScript 전역 `gd` 회귀 확인
  - Files: 기존 LSP 설정 및 테스트 조정이 필요한 경우에만 해당 파일
  - Verify: `scripts/check` 및 filetype별 전역 매핑 정적 확인

## 검증 기준

- `lua/config/keymaps.lua`에는 기존 전역 `gd` 외 Markdown 전용 로직이 없다.
- Java 버퍼에서 `gd`가 기존 JDTLS definition을 호출한다.
- Marksman이 연결된 Markdown 버퍼에서 내부 Markdown 링크가 이동한다.
- 외부 파일 링크의 지원 범위와 실패 메시지가 명시된 테스트를 통과한다.
- Marksman이 없거나 응답하지 않을 때 Neovim 시작이 실패하지 않는다.
- `scripts/check`가 통과한다.

## CEO Review Result

- Mode: HOLD SCOPE
- Issues reviewed: 11
- Decisions accepted: 11
- Unresolved decisions: 0
- Critical gaps: 0
- Verdict: PASS — 범위와 아키텍처가 확정되었으며 spec 작성으로 진행 가능
