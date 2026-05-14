# 우리반 감정 리포트 (MoodBoard)

익명 이모지 투표와 실시간 통계로 **우리 반의 오늘 기분**을 한눈에 보는 학급 심리 대시보드.

## 왜 만드나요?

요즘 반의 의사소통이 부족하다고 느꼈어요. 각자의 감정을 가볍게 공유하면서 서로 더 이해하고 소통할 수 있는 공간을 만들고 싶어서 시작했습니다.

---

## 파일 구조

```
MoodBoard/
├── project_proposer.md      # 학생이 작성한 기획서
├── README.md                # ← 이 파일
├── prompt_example.txt       # Copilot Agent 에게 시킬 프롬프트 예시
├── pubspec.yaml             # Flutter 프로젝트 설명서 (패키지 목록 등)
├── .gitignore               # Git 에 올리지 않을 파일 목록
│
├── lib/                     # 앱의 실제 코드 (Dart)
│   ├── main.dart            # 앱이 시작되는 입구
│   ├── screens/
│   │   └── home_screen.dart # 메인 한 페이지 (배치만 담당)
│   ├── widgets/             # 화면을 구성하는 부품들
│   │   ├── status_bar.dart  # 상단: 실시간 현황 / 대표 이모지
│   │   ├── emoji_vote.dart  # 중앙: 이모지 버튼 + 한 줄 입력
│   │   └── live_board.dart  # 하단: 바 차트 + 흐르는 메시지
│   ├── models/              # 데이터의 모양(설계도)
│   │   ├── mood.dart        # 감정 한 종류
│   │   └── message.dart     # 익명 메시지 한 개
│   └── data/
│       └── mood_repository.dart  # 저장/불러오기 담당
│
├── assets/
│   └── data/                # 데이터 파일 형식 예시 (JSON)
│       ├── votes.json
│       └── messages.json
│
└── web/
    └── index.html           # 브라우저가 처음 여는 페이지
```

> **관심사 분리**: 화면(widgets) / 데이터 모양(models) / 저장(data) 을 폴더로 나눠 두면, 한 부분을 고쳐도 다른 부분이 망가지지 않아요.

---

## 처음 시작하기 (Windows 기준)

### 1. Flutter SDK 설치 (한 번만)

이 프로젝트는 **Flutter Web** 으로 만듭니다. Python / VS Code / Git 외에 Flutter SDK 가 추가로 필요해요.

1. https://docs.flutter.dev/get-started/install/windows 접속
2. Flutter SDK zip 다운로드 → `C:\src\flutter` 같은 경로에 압축 해제
3. **시스템 환경 변수 PATH** 에 `C:\src\flutter\bin` 추가
4. 새 PowerShell 을 열고 아래 명령으로 확인:
   ```powershell
   flutter --version
   flutter doctor
   ```
   `flutter doctor` 에서 빨간 X 가 있으면 안내대로 설치하면 돼요. (Chrome 만 있어도 웹은 됩니다.)

### 2. VS Code 로 프로젝트 열기

1. VS Code 실행 → `파일 > 폴더 열기` → `MoodBoard` 폴더 선택
2. 확장 프로그램에서 **Flutter** 설치 (Dart 도 자동 설치됨)
3. VS Code 메뉴 `터미널 > 새 터미널` 으로 터미널 열기

### 3. Flutter 프로젝트 초기화 (한 번만)

`lib/` 안의 Dart 코드는 베이스라인이 채워져 있지만, Flutter 가 빌드하려면 `android/`, `ios/`, `web/` 자동 생성 파일이 필요해요. 다음 명령으로 채웁니다:

```powershell
flutter create .
flutter pub get
```

> `flutter create .` 는 이미 있는 파일은 덮어쓰지 않으니 안심하고 실행하세요.
> `web/index.html` 은 이미 있을 수도 있는데 그것도 그대로 둡니다.

---

## 페이지 확인하는 방법

Flutter Web 은 일반 HTML 처럼 더블클릭으로 열 수 없어요. 아래 방법을 씁니다.

### 방법 1. `flutter run -d chrome` (개발 중 추천)

```powershell
flutter run -d chrome
```

코드를 수정하면 터미널에서 **`r`** 키를 눌러 즉시 새로고침(hot reload) 할 수 있습니다.

### 방법 2. VS Code 에서 F5

`lib/main.dart` 를 연 상태에서 **F5** (또는 우측 하단 `Chrome (web-javascript)` 클릭). 디버거가 함께 켜져요.

### 방법 3. 빌드한 결과물을 Python 서버로 열기

배포 직전에 "정적 파일이 잘 만들어졌는지" 확인할 때 씁니다.

```powershell
flutter build web
cd build\web
python -m http.server 8000
```

브라우저에서 http://localhost:8000 접속.
`python` 이 안 먹히면 `py -3.12 -m http.server 8000` 으로 시도하세요.

---

## ✅ 지금 동작하는 것 (베이스라인)

`flutter run -d chrome` 으로 켜면 바로 아래가 동작합니다.

- 5개 이모지 버튼(😊 😐 😴 😢 😡)을 누르면 +1 투표 + 차트 실시간 갱신
- 가장 많이 눌린 이모지에 👑 표시 + 총 참여 수
- 익명 한 줄 메시지 입력 → 하단 리스트에 표시
- 데이터는 메모리에만 (새로고침하면 사라짐 — 다음 스텝에서 해결)

## 🌱 앞으로 만들 것 (다음 스텝)

1. **STEP 1** — `shared_preferences` 로 새로고침해도 데이터 유지
2. **STEP 2** — 이모지가 차트로 슝~ 날아가는 애니메이션
3. **STEP 3** — 메시지 전광판 효과 (오른쪽 → 왼쪽으로 흐르기)
4. **STEP 4** — 학급 코드 입력 화면 (여러 반 데이터 분리)
5. **STEP 5** — 가장 많이 눌린 이모지에 짧은 코멘트 추가
6. **STEP 6** — (도전) Firebase Firestore 로 실시간 다중 사용자

> 각 스텝의 자세한 프롬프트는 `prompt_example.txt` 에 있어요.
