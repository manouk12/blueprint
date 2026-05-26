# INIT_PIPELINE_v0.2

순차 실행 필수.

## [0] Constraints
1. 의존성: Phase N 결과물 읽은 후 Phase N+1 실행.
2. 포맷: 3줄 이내 개조식/표 압축.
3. 네이밍: 대문자 스네이크 케이스(`PREFIX_NAME.md`), 대장문서 `INDEX_MASTER.md` 통일.
4. 가드레일: `GUARD_SAFETY.md` 절대 준수.
5. 검열: 각 Phase 종료 시 자가 검열(Self-Reflection) 1회.

## [1] Scan & Guard
- 스캔: 코드베이스, 프레임워크, 기존 설정(`.cursorrules`, `package.json` 등).
- 생성: `docs/.ai-context/GUARD_SAFETY.md` (덮어쓰기 금지, 삭제 전 확인, 백업 필수 규칙).

## [2] Profile
- 읽기: `GUARD_SAFETY.md`
- 생성: `docs/.ai-context/PROFILE_PROJECT.md` (프로젝트 요약, 4종 페르소나(Architect, Developer, DBA, Tester) 정의 표).

## [3] Cascading Rules
- 읽기: `PROFILE_PROJECT.md`
- 생성:
  1. `docs/.ai-context/STATE_SWITCHES.md` (상태 스위치. 생성 시 기본값: `[x] MASTER_AUTO_SDLC`, `[x] MODE_PLANNING` 활성화)
  2. `.cursorrules` (진입점. 내부 룰 기재 금지. 작업 전 `STATE_SWITCHES.md`, `INDEX_KEYWORDS.md` 읽기 강제. 기존 파일 병합)
  3. `docs/.ai-context/RULE_ARCHITECTURE.md` (폴더 구조, 의존성 제약)
  4. `docs/.ai-context/RULE_CONVENTION.md` (네이밍, 포맷팅, Git)
  5. `docs/.ai-context/RULE_DB_API.md` (DB 추측 금지, API 명세 제약)
  6. `docs/.ai-context/TRACKER_TECH_DEBT.md` (TODO/기술 부채 기록용)
  7. `docs/.ai-context/TEMPLATE_WORK_LOG.md` (작업 내용/결과 기록 템플릿)
  8. `docs/.ai-context/TEMPLATE_HANDOFF.md` (인수인계 템플릿. 현재 상태/에러/목표 기록용)
  9. `docs/.ai-context/RULE_DOCS.md` (새로운 기능/프로젝트 요청 시 절대 코드부터 짜지 말고, `docs/architect_docs/` 하위에 [1_요구사항분석, 2_아키텍처_및_인프라, 3_DB스키마, 4_API설계, 5_폴더구조, 6_화면기획, 7_트러블슈팅] 폴더 트리를 따르는 기획 문서 풀세트를 선행 생성하여 컨펌받도록 강제하는 룰)

## [4] Guide
- 생성: `docs/.ai-context/GUIDE_VIBE.md` (프롬프트 작성 템플릿/예시).

## [5] Consolidation & Routing
- 수집: Phase 1~4 생성 문서.
- 생성: 
  1. `docs/.ai-context/INDEX_MASTER.md` (생성 파일 구조적 목차)
  2. `docs/.ai-context/INDEX_KEYWORDS.md` (키워드 라우터. 예: `@handoff -> TEMPLATE_HANDOFF.md`, `@docs -> RULE_DOCS.md`. 프롬프트 내 키워드 감지 시 해당 문서만 읽기 강제)
  3. `docs/persona/INDEX_MASTER.md` (페르소나 목차)

## [6] Report & Archive
- 검수: 룰 충돌 및 `INDEX_MASTER.md` 링크 유효성 교차 검증.
- 완료: 터미널 `REPORT_SETUP_DONE` 출력.
- 보존: 현재 읽고 실행 중인 원본 블루프린트 파일(이 문서 자체)을 `docs/.ai-context/archive/` 폴더로 이동 (초기화 중복 실행 방지 목적).
