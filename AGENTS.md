# AGENTS.md

## 프로젝트 기준

이 저장소는 iOS용 SwiftUI overflow menu 컴포넌트인 `OverflowMenuUI`를
제공하는 Swift Package입니다.

## 설계 원칙

- public API와 내부 구조를 변경할 때는 SOLID 설계 원칙을 따릅니다.
- 각 타입은 하나의 책임에 집중합니다. 실제 복잡도를 줄이거나 소유 경계를
  명확히 할 때만 타입을 분리합니다.
- 기존 호출부를 깨는 변경보다 view builder, 설정값, 작은 전용 타입을 통한
  확장을 우선합니다.
- public API는 안정적으로 유지하고 DocC 주석을 함께 관리합니다.
- 커스터마이징 옵션을 추가할 때는 기존 기본 동작을 보존합니다.
- 요청 범위 밖의 대규모 리팩터링은 피합니다.
- SwiftUI View는 조합 가능하고 예측 가능하며 독립적으로 확인하기 쉽게
  유지합니다.

## Swift Package 규칙

- `swift-tools-version`은 프로젝트 요구사항과 일치시킵니다.
- `Package.swift`에 이미 있는 Swift Package Manager 관례를 따릅니다.
- 프로젝트 요구사항이 바뀌기 전까지 iOS 17.0 이상을 대상으로 합니다.
- `.build/`, `.swiftpm/`, `docs/`, `*.doccarchive` 같은 생성 산출물은
  커밋하지 않습니다.

## 문서화 규칙

- public API, 패키지 설정, 배포 동작이 바뀌면 README와 DocC 문서를 함께
  업데이트합니다.
- DocC 생성 결과물은 로컬 검증 중에만 `docs/`에 둘 수 있으며 커밋하지
  않습니다.
- 문서 관련 변경을 배포하기 전에는 `GeneratingDocumentationSite`로 DocC
  생성을 검증합니다.

## 브랜치, 커밋, PR 규칙

- 브랜치명과 PR 제목은 `feat.`, `fix.`, `chore.`, `hotfix.`, `env.`처럼
  의미 있는 prefix를 사용합니다.
- 브랜치명, PR 제목, PR 본문에는 `codex`를 사용하지 않습니다.
- 커밋 메시지와 PR 설명은 한국어로 작성하고, 변경 의도와 검증 내용을
  리뷰어가 이해할 수 있게 자세히 적습니다.
- PR은 사용자가 별도로 요청하지 않는 한 즉시 Ready 상태로 생성합니다.
