import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge.dart';
import '../services/challenge_service.dart';
import 'package:intl/intl.dart';

class ChallengeDetailScreen extends ConsumerWidget {
  final String challengeId;

  const ChallengeDetailScreen({
    super.key,
    required this.challengeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('챌린지 상세'),
        backgroundColor: Colors.green.shade800,
      ),
      body: FutureBuilder<Challenge?>(
        future: ChallengeService.getChallenge(challengeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          }

          final challenge = snapshot.data;
          if (challenge == null) {
            return const Center(child: Text('챌린지를 찾을 수 없습니다.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChallengeHeader(challenge),
                const SizedBox(height: 24),
                _buildProgressSection(challenge),
                const SizedBox(height: 24),
                _buildParticipantsSection(challenge),
                if (challenge.isActive) ...[
                  const SizedBox(height: 24),
                  _buildActionButtons(context, challenge),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChallengeHeader(Challenge challenge) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Card(
      color: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green.shade200, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: challenge.isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    challenge.isActive ? '진행 중' : '종료',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              challenge.description,
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '시작일: ${dateFormat.format(challenge.startDate)}',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                Text(
                  '종료일: ${dateFormat.format(challenge.endDate)}',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(Challenge challenge) {
    final totalDays = challenge.endDate.difference(challenge.startDate).inDays + 1;
    final currentDay = DateTime.now().difference(challenge.startDate).inDays + 1;
    final progressPercent = (currentDay / totalDays).clamp(0.0, 1.0);

    return Card(
      color: Colors.grey.shade800,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '진행 현황',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progressPercent,
              backgroundColor: Colors.grey.shade700,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
            ),
            const SizedBox(height: 8),
            Text(
              'D+$currentDay',
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsSection(Challenge challenge) {
    return Card(
      color: Colors.grey.shade800,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '참여자',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${challenge.participants.length}명',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: challenge.participants.length,
              itemBuilder: (context, index) {
                final participantId = challenge.participants[index];
                final score = challenge.participantScores[participantId] ?? 0;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  title: Text(
                    '참여자 ${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    '$score점',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    Challenge challenge,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showUpdateScoreDialog(context, challenge);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '점수 업데이트',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (challenge.creatorId == FirebaseService.currentUserId) ...[
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showEndChallengeDialog(context, challenge);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '챌린지 종료',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showUpdateScoreDialog(
    BuildContext context,
    Challenge challenge,
  ) {
    final scoreController = TextEditingController();
    final currentScore = challenge.participantScores[FirebaseService.currentUserId] ?? 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('점수 업데이트'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('현재 점수: $currentScore점'),
            const SizedBox(height: 16),
            TextField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '추가할 점수',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final score = int.tryParse(scoreController.text);
              if (score == null || score <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('유효한 점수를 입력해주세요'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              await ChallengeService.updateScore(challenge.id, score);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('점수가 업데이트되었습니다!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showEndChallengeDialog(
    BuildContext context,
    Challenge challenge,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('챌린지 종료'),
        content: const Text('정말로 챌린지를 종료하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ChallengeService.endChallenge(challenge.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('챌린지가 종료되었습니다.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('종료'),
          ),
        ],
      ),
    );
  }
} 