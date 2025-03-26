# 행복 기록 (HappiLog) 📱✨

<div align="center">
  <img src="https://github.com/octxxiii/HL/raw/main/assets/happilog_banner.png" alt="HappiLog Banner" width="600">
  <p><i>매일 한 번, 소소한 행복을 기록하고 성장하세요</i></p>
</div>

## 🌟 소개

**HappiLog**는 매일의 작은 행복을 도트 그래픽 스타일로 기록할 수 있는 모바일 앱입니다. 하루에 한 번, 당신의 행복한 순간을 사진과 텍스트로 기록하면 귀여운 픽셀 아바타가 당신의 감정 상태에 따라 변화합니다. 

기록이 쌓일수록 아바타는 점점 성장하고, 당신만의 고유한 행복 캘린더가 완성됩니다. 친구들과 랭킹도 비교하고, 특별한 순간은 독특한 말풍선 스타일로 공유해보세요!

## ✨ 주요 기능

- **일일 행복 기록**: 하루에 한 번, 텍스트와 사진으로 행복한 순간을 기록
- **감정 캘린더**: 한 눈에 보는 월별 감정 상태 캘린더
- **픽셀 아바타**: 기록 수와 감정에 따라 변화하는 귀여운 픽셀 아바타
- **랭킹 시스템**: 친구들과 행복 기록 수 비교
- **말풍선 공유**: 특별한 순간을 도트 스타일 말풍선으로 소셜 미디어에 공유
- **행복 알림**: 매일 기록을 잊지 않도록 맞춤 알림 설정

## 📱 스크린샷

<div align="center">
  <div style="display: flex; justify-content: space-between;">
    <img src="https://github.com/octxxiii/HL/raw/main/assets/screenshots/home_screen.png" alt="홈 화면" width="200">
    <img src="https://github.com/octxxiii/HL/raw/main/assets/screenshots/record_screen.png" alt="기록 화면" width="200">
    <img src="https://github.com/octxxiii/HL/raw/main/assets/screenshots/calendar_screen.png" alt="캘린더 화면" width="200">
  </div>
</div>

## 🛠️ 기술 스택

- **프론트엔드**: Flutter
- **상태 관리**: Riverpod
- **백엔드**: Firebase (Authentication, Firestore, Storage)
- **스타일**: 픽셀 아트, 다크 모드 기반 UI/UX

## 🚀 설치 방법

1. Flutter SDK 설치 (2.0 이상)
2. Firebase 프로젝트 설정
3. 저장소 클론
```bash
git clone https://github.com/octxxiii/HL.git
cd HL/happilog
flutter pub get
```
4. `google-services.json`/`GoogleService-Info.plist` 파일 추가
5. 앱 실행
```bash
flutter run
```

## 📊 프로젝트 구조

```
happilog/
├── lib/
│   ├── models/       # 데이터 모델
│   ├── providers/    # 상태 관리
│   ├── screens/      # 앱 화면
│   ├── services/     # 서비스 로직 
│   ├── utils/        # 유틸리티 함수
│   ├── widgets/      # 재사용 위젯
│   └── main.dart     # 앱 진입점
├── assets/           # 이미지와 폰트
└── test/             # 테스트 코드
```

## 🎯 릴리즈 플랜

| 버전 | 목표 | 상태 |
|------|------|------|
| v0.1 | MVP (기록, 아바타, 캘린더) | ✅ 완료 |
| v0.5 | 랭킹/공유 기능 | 🔄 진행중 |
| v1.0 | 앱 스토어 출시 | 🔜 예정 |
| v1.1+ | 테마 커스터마이징 | 🔜 예정 |

## 📝 라이선스

MIT 라이선스

## 👨‍💻 개발자

독립 개발자 프로젝트 - Cursor + GPT 자동화 기반 개발

---

<div align="center">
  <p>✨ 매일 기록하는 작은 행복이 쌓여 커다란 기쁨이 됩니다 ✨</p>
  <a href="https://github.com/octxxiii/HL/issues">버그 신고</a> · 
  <a href="https://github.com/octxxiii/HL/issues">기능 제안</a>
</div> 