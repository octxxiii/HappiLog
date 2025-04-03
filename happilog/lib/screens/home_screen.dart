import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:happilog/components/pixel_avatar.dart';
import 'package:happilog/components/pixel_button.dart';
import 'package:happilog/components/pixel_speech_bubble.dart';
import 'package:happilog/models/daily_record.dart';
import 'package:happilog/providers/providers.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsyncValue = ref.watch(recordListProvider);
    final userDataAsyncValue = ref.watch(userProvider);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            
            // 타이틀
            const Text(
              '행복 기록',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 24,
                color: Colors.amber,
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              'HAPPILOG',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 아바타 섹션
            userDataAsyncValue.when(
              data: (userData) {
                final String nickname = userData?['nickname'] ?? '행복이';
                final int recordCount = userData?['recordCount'] ?? 0;
                
                return Column(
                  children: [
                    const PixelAvatar(size: 100),
                    const SizedBox(height: 16),
                    Text(
                      nickname,
                      style: const TextStyle(
                        fontFamily: 'NanumGothicCoding',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '기록 횟수: $recordCount',
                      style: const TextStyle(
                        fontFamily: 'NanumGothicCoding',
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('사용자 정보를 불러올 수 없습니다.'),
            ),
            
            const SizedBox(height: 32),
            
            // 최근 기록 섹션
            const Text(
              '최근 기록',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Expanded(
              child: recordsAsyncValue.when(
                data: (records) {
                  if (records.isEmpty) {
                    return const Center(
                      child: Text(
                        '아직 기록이 없습니다.\n첫 행복 기록을 남겨보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'NanumGothicCoding',
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: records.length > 5 ? 5 : records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return _buildRecordItem(context, record);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('기록을 불러올 수 없습니다.')),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 기록하기 버튼
            PixelButton(
              text: '오늘의 행복 기록하기',
              onPressed: () {
                context.go('/record');
              },
              width: 220,
            ),
            
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavigationButton(
                  context,
                  Icons.home,
                  '홈',
                  '/',
                ),
                _buildNavigationButton(
                  context,
                  Icons.calendar_today,
                  '캘린더',
                  '/calendar',
                ),
                _buildNavigationButton(
                  context,
                  Icons.add_circle,
                  '기록',
                  '/record',
                ),
                _buildNavigationButton(
                  context,
                  Icons.emoji_events,
                  '챌린지',
                  '/challenge',
                ),
                _buildNavigationButton(
                  context,
                  Icons.person,
                  '아바타',
                  '/avatar',
                ),
                _buildNavigationButton(
                  context,
                  Icons.leaderboard,
                  '랭킹',
                  '/ranking',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecordItem(BuildContext context, DailyRecord record) {
    final formatter = DateFormat('MM/dd');
    final dateStr = formatter.format(record.date);
    
    return GestureDetector(
      onTap: () {
        context.go('/entry/${record.id}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // 감정 아이콘
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _getEmotionColor(record.emotion),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: Center(
                child: _getEmotionIcon(record.emotion),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // 텍스트 내용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.text.length > 30 
                        ? '${record.text.substring(0, 30)}...' 
                        : record.text,
                    style: const TextStyle(
                      fontFamily: 'NanumGothicCoding',
                      fontSize: 14,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontFamily: 'NanumGothicCoding',
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // 이미지 표시
            if (record.imageUrl != null)
              const Icon(
                Icons.image,
                size: 16,
                color: Colors.white70,
              ),
          ],
        ),
      ),
    );
  }
  
  Color _getEmotionColor(Emotion emotion) {
    switch (emotion) {
      case Emotion.happy:
        return Colors.amber;
      case Emotion.sad:
        return Colors.blue;
      case Emotion.neutral:
        return Colors.grey;
    }
  }
  
  Widget _getEmotionIcon(Emotion emotion) {
    switch (emotion) {
      case Emotion.happy:
        return const Icon(Icons.sentiment_satisfied, size: 16, color: Colors.black);
      case Emotion.sad:
        return const Icon(Icons.sentiment_dissatisfied, size: 16, color: Colors.white);
      case Emotion.neutral:
        return const Icon(Icons.sentiment_neutral, size: 16, color: Colors.white);
    }
  }
  
  Widget _buildNavigationButton(BuildContext context, IconData icon, String label, String route) {
    return TextButton(
      onPressed: () {
        context.go(route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'NanumGothicCoding',
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
} 