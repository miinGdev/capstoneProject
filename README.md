# 📱 Capstone Project

Flutter 기반 크로스 플랫폼 애플리케이션입니다.  
본 프로젝트는 Android, iOS, Web, Windows 등 다양한 운영체제에서 실행 가능하며, Firebase를 이용한 인증 및 클라우드 데이터 연동 기능을 포함합니다.

---

## 🚀 주요 기능

- Firebase 연동 (인증, 데이터 저장 등)
- 크로스 플랫폼 지원 (Android, iOS, Web, Windows)
- 직관적인 UI 구성
- Flutter로 구축된 반응형 앱

---

## 📁 폴더 구조 설명

```
capstoneProject/
├── android/           # Android 빌드 및 설정 파일
├── ios/               # iOS 빌드 및 설정 파일
├── web/               # Web 플랫폼 관련 설정
├── windows/           # Windows 앱 설정
├── macos/, linux/     # 데스크탑 운영체제별 설정
├── build/             # 빌드시 자동 생성되는 임시 폴더 (Git 추적 제외)
├── lib/               # Flutter 애플리케이션 핵심 코드
│   ├── screens/       # 화면 UI 위젯 파일 모음
│   ├── main.dart      # 앱 시작 지점 (main 함수)
│   ├── app.dart       # 앱 전반 설정 및 라우팅
│   └── firebase_options.dart # Firebase 초기화 설정
├── test/              # 테스트 코드
├── pubspec.yaml       # 프로젝트 의존성 설정
├── analysis_options.yaml # 코드 분석 규칙 설정
└── README.md          # 프로젝트 설명 파일
```

---

## 🔧 실행 방법

1. Flutter 환경이 구성되어 있어야 합니다.
2. Firebase 설정이 포함된 `google-services.json` 또는 `GoogleService-Info.plist`가 있어야 합니다.
3. 아래 명령어로 실행하세요.

```bash
flutter pub get
flutter run
```

---

## 📌 기술 스택

- Flutter / Dart
- Firebase (Authentication, Firestore 등)
- 플랫폼: Android, iOS, Web, Windows

---

## 🧑‍💻 개발자

- 팀명 또는 캡스톤 조 이름
- 담당자 GitHub ID 등 (필요시 기입)

---

## 📄 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다. (원하면 수정 가능)
