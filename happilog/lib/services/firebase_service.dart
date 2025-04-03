import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:happilog/models/daily_record.dart';
import 'package:happilog/models/challenge.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // 사용자 컬렉션 참조
  static CollectionReference get usersCollection => 
      _firestore.collection('users');

  // 현재 사용자 ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // 현재 사용자 레코드 컬렉션 참조
  static CollectionReference get recordsCollection => 
      usersCollection.doc(currentUserId).collection('records');

  // 익명 로그인
  static Future<UserCredential> signInAnonymously() async {
    try {
      // 이미 로그인되어 있는 경우
      if (_auth.currentUser != null) {
        // 이미 로그인한 경우에는 새로 로그인하지 않고 현재 로그인된 사용자 정보를 반환
        // UserCredential을 직접 생성할 수 없으므로, 대신 다시 익명 로그인을 수행
        return await _auth.signInAnonymously();
      }
      
      // 익명 로그인
      final UserCredential userCredential = await _auth.signInAnonymously();
      
      // 새 사용자인 경우 초기 데이터 설정
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final randomNickname = "행복이${const Uuid().v4().substring(0, 6)}";
        await usersCollection.doc(userCredential.user!.uid).set({
          'nickname': randomNickname,
          'createdAt': FieldValue.serverTimestamp(),
          'recordCount': 0,
        });
      }
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // 사용자 정보 가져오기
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (currentUserId == null) return null;
      
      final DocumentSnapshot doc = 
          await usersCollection.doc(currentUserId).get();
      
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // 닉네임 업데이트
  static Future<void> updateNickname(String nickname) async {
    try {
      if (currentUserId == null) return;
      
      await usersCollection.doc(currentUserId).update({
        'nickname': nickname,
      });
    } catch (e) {
      rethrow;
    }
  }

  // 이미지 업로드
  static Future<String> uploadImage(File imageFile) async {
    try {
      final String fileName = '${currentUserId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child('images/$fileName');
      
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  // 기록 저장
  static Future<DailyRecord> saveRecord(DailyRecord record) async {
    try {
      if (currentUserId == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }
      
      // Firestore에 기록 저장
      await recordsCollection.doc(record.id).set(record.toMap());
      
      // 사용자의 기록 수 증가
      await usersCollection.doc(currentUserId).update({
        'recordCount': FieldValue.increment(1),
      });
      
      return record;
    } catch (e) {
      rethrow;
    }
  }

  // 기록 가져오기
  static Future<DailyRecord?> getRecord(String recordId) async {
    try {
      if (currentUserId == null) return null;
      
      final DocumentSnapshot doc = 
          await recordsCollection.doc(recordId).get();
      
      if (doc.exists) {
        return DailyRecord.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // 모든 기록 가져오기
  static Stream<List<DailyRecord>> getRecords() {
    try {
      if (currentUserId == null) {
        return Stream.value([]);
      }
      
      return recordsCollection
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DailyRecord.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  // 특정 날짜의 기록 가져오기
  static Stream<List<DailyRecord>> getRecordsByDate(DateTime date) {
    try {
      if (currentUserId == null) {
        return Stream.value([]);
      }
      
      final DateTime startOfDay = DateTime(date.year, date.month, date.day);
      final DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
      
      return recordsCollection
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DailyRecord.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  // 랭킹 가져오기
  static Stream<List<Map<String, dynamic>>> getRankings() {
    try {
      return usersCollection
          .orderBy('recordCount', descending: true)
          .limit(20)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                return data;
              })
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  // 챌린지 관련 메서드
  static Future<String> createChallenge({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (currentUserId == null) {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }

    final challenge = Challenge(
      id: '',
      title: title,
      description: description,
      creatorId: currentUserId!,
      participants: [currentUserId!],
      startDate: startDate,
      endDate: endDate,
      participantScores: {currentUserId!: 0},
      isActive: true,
    );

    final docRef = await _firestore.collection('challenges').add(challenge.toMap());
    return docRef.id;
  }

  static Future<void> joinChallenge(String challengeId) async {
    if (currentUserId == null) {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }

    await _firestore.collection('challenges').doc(challengeId).update({
      'participants': FieldValue.arrayUnion([currentUserId]),
      'participantScores.$currentUserId': 0,
    });
  }

  static Future<void> updateScore(String challengeId, int score) async {
    if (currentUserId == null) {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }

    await _firestore.collection('challenges').doc(challengeId).update({
      'participantScores.$currentUserId': FieldValue.increment(score),
    });
  }

  static Stream<List<Challenge>> getUserChallenges() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('challenges')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Challenge.fromMap(doc.data()!, doc.id))
            .toList());
  }

  static Stream<List<Challenge>> getActiveChallenges() {
    return _firestore
        .collection('challenges')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Challenge.fromMap(doc.data()!, doc.id))
            .toList());
  }

  static Future<Challenge?> getChallenge(String challengeId) async {
    final doc = await _firestore.collection('challenges').doc(challengeId).get();
    if (!doc.exists) return null;
    return Challenge.fromMap(doc.data()!, doc.id);
  }

  static Future<void> endChallenge(String challengeId) async {
    if (currentUserId == null) {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }

    final challenge = await getChallenge(challengeId);
    if (challenge == null) {
      throw Exception('챌린지를 찾을 수 없습니다.');
    }

    if (challenge.creatorId != currentUserId) {
      throw Exception('챌린지 생성자만 종료할 수 있습니다.');
    }

    await _firestore.collection('challenges').doc(challengeId).update({
      'isActive': false,
    });
  }
} 