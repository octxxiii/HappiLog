# HappiLog - 행복 기록 앱

<div align="center">
  <p><i>매일 한 번, 소소한 행복을 기록하고 도트 아바타와 함께 성장하세요</i></p>
</div>

## 앱 소개

**HappiLog**는 매일의 작은 행복을 도트 그래픽 스타일로 기록할 수 있는 모바일 앱입니다. 
하루에 한 번, 당신의 행복한 순간을 사진과 텍스트로 기록하면 귀여운 픽셀 아바타가 당신의 감정 상태에 따라 변화합니다.

## 주요 기능

- **일일 행복 기록**: 하루에 한 번, 텍스트와 사진으로 행복한 순간을 기록
- **감정 캘린더**: 한 눈에 보는 월별 감정 상태 캘린더
- **픽셀 아바타**: 기록 수와 감정에 따라 변화하는 귀여운 픽셀 아바타
- **랭킹 시스템**: 친구들과 행복 기록 수 비교
- **말풍선 공유**: 특별한 순간을 도트 스타일 말풍선으로 소셜 미디어에 공유

## 설치 및 실행 방법

### 요구사항
- Flutter SDK (2.0 이상)
- Firebase 프로젝트 설정
- Android Studio 또는 VS Code

### 설치 단계
1. 저장소 클론
   ```bash
   git clone https://github.com/octxxiii/HL.git
   cd HL/happilog
   ```

2. 패키지 설치
   ```bash
   flutter pub get
   ```

3. Firebase 설정 파일 추가
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

4. 앱 실행
   ```bash
   flutter run
   ```

## 배포 준비

### Android 앱 서명 설정
```bash
# 키스토어 생성
keytool -genkey -v -keystore ~/happilog.jks -keyalg RSA -keysize 2048 -validity 10000 -alias happilog

# 앱 빌드
flutter build appbundle
```

## 기술 스택

- **프론트엔드**: Flutter
- **상태 관리**: Riverpod
- **백엔드**: Firebase (Authentication, Firestore, Storage)
- **스타일**: 픽셀 아트, 다크 모드 기반 UI/UX

## 프로젝트 구조

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

## 스크린샷

(앱 스크린샷은 추후 추가 예정입니다)

## 라이선스

MIT 라이선스
