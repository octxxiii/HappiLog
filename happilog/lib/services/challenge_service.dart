import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge.dart';
import 'firebase_service.dart';

class ChallengeService {
  static Future<String> createChallenge({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await FirebaseService.createChallenge(
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
    );
  }

  static Future<void> joinChallenge(String challengeId) async {
    await FirebaseService.joinChallenge(challengeId);
  }

  static Future<void> updateScore(String challengeId, int score) async {
    await FirebaseService.updateScore(challengeId, score);
  }

  static Stream<List<Challenge>> getUserChallenges() {
    return FirebaseService.getUserChallenges();
  }

  static Stream<List<Challenge>> getActiveChallenges() {
    return FirebaseService.getActiveChallenges();
  }

  static Future<Challenge?> getChallenge(String challengeId) async {
    return await FirebaseService.getChallenge(challengeId);
  }

  static Future<void> endChallenge(String challengeId) async {
    await FirebaseService.endChallenge(challengeId);
  }
} 