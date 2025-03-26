import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happilog/models/daily_record.dart';
import 'package:happilog/services/firebase_service.dart';

// 현재 선택된 날짜를 관리하는 Provider
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// 사용자 정보 Provider
final userProvider = StreamProvider<Map<String, dynamic>?>((ref) async* {
  // 초기 데이터 로드
  final initialData = await FirebaseService.getUserData();
  yield initialData;
  
  // Firestore 변경 사항 수신
  final stream = FirebaseService.usersCollection
      .doc(FirebaseService.currentUserId)
      .snapshots()
      .map((snapshot) => snapshot.data() as Map<String, dynamic>?);
  
  await for (final data in stream) {
    yield data;
  }
});

// 전체 기록 목록 Provider
final recordListProvider = StreamProvider<List<DailyRecord>>((ref) {
  return FirebaseService.getRecords();
});

// 선택된 날짜의 기록 Provider
final selectedDateRecordsProvider = StreamProvider<List<DailyRecord>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  return FirebaseService.getRecordsByDate(selectedDate);
});

// 랭킹 리스트 Provider
final rankingsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseService.getRankings();
});

// 아바타 상태 Provider
final avatarStatusProvider = Provider<String>((ref) {
  final userDataAsyncValue = ref.watch(userProvider);
  
  return userDataAsyncValue.when(
    data: (userData) {
      if (userData == null) return 'neutral';
      
      final int recordCount = userData['recordCount'] ?? 0;
      
      if (recordCount == 0) return 'neutral';
      if (recordCount <= 5) return 'happy';
      if (recordCount <= 10) return 'star';
      return 'glow';
    },
    loading: () => 'neutral',
    error: (_, __) => 'neutral',
  );
}); 