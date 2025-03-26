import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happilog/models/daily_record.dart';

class MockFirebaseService {
  final FakeFirebaseFirestore firestore;
  final MockFirebaseAuth auth;
  
  MockFirebaseService({
    FakeFirebaseFirestore? firestore,
    MockFirebaseAuth? auth,
  }) : 
    this.firestore = firestore ?? FakeFirebaseFirestore(),
    this.auth = auth ?? MockFirebaseAuth();
  
  // 모킹된 collections 참조
  CollectionReference get usersCollection => firestore.collection('users');
  
  String? get currentUserId => auth.currentUser?.uid;
  
  CollectionReference get recordsCollection => 
      usersCollection.doc(currentUserId ?? 'test-user').collection('records');
  
  // 레코드 저장 테스트 함수
  Future<DailyRecord> saveRecord(DailyRecord record) async {
    await recordsCollection.doc(record.id).set(record.toMap());
    
    // 사용자의 기록 수 업데이트
    await usersCollection.doc(currentUserId ?? 'test-user').update({
      'recordCount': FieldValue.increment(1),
    });
    
    return record;
  }
  
  // 레코드 조회 테스트 함수
  Future<DailyRecord?> getRecord(String recordId) async {
    final doc = await recordsCollection.doc(recordId).get();
    
    if (doc.exists) {
      return DailyRecord.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
  
  // 현재 날짜의 레코드 목록 조회 테스트 함수
  Future<List<DailyRecord>> getRecordsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final snapshot = await recordsCollection
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();
        
    return snapshot.docs
        .map((doc) => DailyRecord.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

void main() {
  late MockFirebaseService mockService;
  late MockUser testUser;
  
  setUp(() {
    // 테스트 사용자 설정
    testUser = MockUser(
      uid: 'test-user',
      isAnonymous: true,
    );
    
    // 모의 인증 서비스 설정
    final mockAuth = MockFirebaseAuth(mockUser: testUser);
    final mockFirestore = FakeFirebaseFirestore();
    
    // 테스트 데이터 초기화
    mockFirestore.collection('users').doc('test-user').set({
      'nickname': '테스트사용자',
      'createdAt': Timestamp.now(),
      'recordCount': 0,
    });
    
    mockService = MockFirebaseService(
      firestore: mockFirestore,
      auth: mockAuth,
    );
  });
  
  group('Firebase 서비스 테스트', () {
    test('레코드 저장 및 조회 테스트', () async {
      // 테스트 레코드 생성
      final now = DateTime.now();
      final record = DailyRecord(
        id: 'test-record-id',
        text: '테스트 기록입니다.',
        emotion: Emotion.happy,
        date: now,
      );
      
      // 레코드 저장
      await mockService.saveRecord(record);
      
      // 레코드 조회
      final savedRecord = await mockService.getRecord('test-record-id');
      
      // 검증
      expect(savedRecord, isNotNull);
      expect(savedRecord!.id, equals('test-record-id'));
      expect(savedRecord.text, equals('테스트 기록입니다.'));
      expect(savedRecord.emotion, equals(Emotion.happy));
      
      // 사용자 레코드 카운트 업데이트 확인
      final userDoc = await mockService.usersCollection.doc('test-user').get();
      final userData = userDoc.data() as Map<String, dynamic>;
      expect(userData['recordCount'], equals(1));
    });
    
    test('날짜별 레코드 조회 테스트', () async {
      // 현재 날짜의 레코드
      final today = DateTime.now();
      final todayRecord1 = DailyRecord(
        id: 'today-record-1',
        text: '오늘의 첫 번째 기록',
        emotion: Emotion.happy,
        date: today,
      );
      final todayRecord2 = DailyRecord(
        id: 'today-record-2',
        text: '오늘의 두 번째 기록',
        emotion: Emotion.neutral,
        date: today,
      );
      
      // 어제 날짜의 레코드
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      final yesterdayRecord = DailyRecord(
        id: 'yesterday-record',
        text: '어제의 기록',
        emotion: Emotion.sad,
        date: yesterday,
      );
      
      // 레코드 저장
      await mockService.saveRecord(todayRecord1);
      await mockService.saveRecord(todayRecord2);
      await mockService.saveRecord(yesterdayRecord);
      
      // 오늘 날짜의 레코드만 조회
      final todayRecords = await mockService.getRecordsByDate(today);
      
      // 검증
      expect(todayRecords.length, equals(2));
      expect(todayRecords.any((r) => r.id == 'today-record-1'), isTrue);
      expect(todayRecords.any((r) => r.id == 'today-record-2'), isTrue);
      expect(todayRecords.any((r) => r.id == 'yesterday-record'), isFalse);
      
      // 어제 날짜의 레코드만 조회
      final yesterdayRecords = await mockService.getRecordsByDate(yesterday);
      
      // 검증
      expect(yesterdayRecords.length, equals(1));
      expect(yesterdayRecords.first.id, equals('yesterday-record'));
    });
  });
} 