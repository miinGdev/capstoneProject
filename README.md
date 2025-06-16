# 📱 Capstone Project

Flutter 기반 크로스 플랫폼 애플리케이션입니다.  
본 프로젝트는 Android, iOS, Web, Windows 등 다양한 운영체제에서 실행 가능하며, Firebase를 이용한 인증 및 클라우드 데이터 연동 기능을 포함합니다.

**멀티 플랫폼** 대응, **실시간 감정 분석 및 대화 요약**, **GPT 파인튜닝 말투 대응** 등을 구현했습니다.

---

## 🚀 핵심 기능

### 🔹 프론트엔드 (Flutter)
- Firebase를 활용한 사용자 인증 (Google 로그인 등)
- 반응형 UI (Android, iOS, Web, Windows 대응)
- 말투 선택 기능 (ex: 집사, 시크, 츤데레 등 6가지 말투)
- 요약/감정 분석 기능 연동

### 🔹 백엔드 (FastAPI)
- GPT-4o 기반 챗봇 API (`/chat`)
- GPT-4o 요약봇 API (`/summary`)
- 말투별 system 프롬프트 적용 (`tone_prompts`)
- RAG/FAISS (선택적 구성) 통한 밈/사투리 처리 가능

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

## 💬 사용 가능한 말투 목록

- 귀여운
- 집사
- 시크
- 집착
- 츤데레  
- 오타쿠
- 경상도 사투리
- 전라도 사투리
- 최신 밈 말투

> 원하는 말투가 없다면 `"기본"`으로 설정되어 자연스럽게 응답합니다.

---

## 📌 기술 스택

## 프론트엔드 
- Flutter / Dart / Firebase

## 백엔드
- Python
- httpx
- FastAPI
- node.js
- mongo DB

## AI
- OpenAI GPT 4o
- RAG+FAISS
- Sentence-Transformers

---

## 🧑‍💻 개발자

- 성신팀
- 강민지, 김예원, 김유리, 김채원, 문현수, 신하령, 황현정

---

## 📄 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다. 
