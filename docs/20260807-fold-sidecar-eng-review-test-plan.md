# Markdown fold sidecar Eng Review 테스트 계획

생성: `/plan-eng-review` 2026-08-07
브랜치: `main`

## 대상

- Neovim Markdown 버퍼
- Markdown 본문을 수정하지 않고 manual fold 상태를 sidecar JSON으로 공유하는 흐름

## 핵심 상호작용

- sidecar가 없는 Markdown 파일을 열기만 했을 때 JSON이 생성되지 않아야 한다.
- `V`로 범위를 선택하고 `zf`를 실행하면 정규화된 시작·끝 anchor가 v2 sidecar에 저장되어야 한다.
- normal-mode `zf`도 native 동작을 유지하면서 sidecar에 저장되어야 한다.
- `zo`를 실행하면 현재 fold에 해당하는 entry만 제거되어야 한다.
- 문서에 줄을 삽입하고 Neovim을 재시작해도 같은 내용 범위가 복원되어야 한다.
- 다른 PC에서 sidecar를 pull한 뒤 동일한 anchor 범위가 복원되어야 한다.

## 경계 조건

- 빈 줄만 선택한 경우 저장하지 않아야 한다.
- anchor가 없거나 중복되거나 parent heading이 모호하면 잘못된 위치를 접지 않고 skip해야 한다.
- 중첩 fold는 복원하고, 부분적으로 겹치는 fold는 저장하지 않아야 한다.
- 기존 v1 sidecar는 읽고, 다음 `zf`/`zo` 시 v2로 전환해야 한다.
- 잘못된 JSON은 복원을 건너뛰고, atomic write 실패는 편집을 유지하면서 warning을 표시해야 한다.

## 필수 흐름

- `V` → `zf` → 닫기 → 다시 열기 → anchor fold 복원
- `zo` → 문서 수정 → `zf` → 새 anchor로 sidecar upsert
- Markdown 이외 파일은 기존 `mkview`/`loadview` 동작을 유지

## 실행 방식

- 새 외부 테스트 의존성 없이 Neovim headless 테스트로 검증한다.
- anchor 정규화·매칭은 단위 수준으로, 실제 `zf`/`zo`·재시작·sidecar 생성은 통합 수준으로 검증한다.
