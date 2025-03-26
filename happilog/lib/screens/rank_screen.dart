import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happilog/components/pixel_avatar.dart';
import 'package:happilog/providers/providers.dart';
import 'package:happilog/services/firebase_service.dart';

class RankScreen extends ConsumerWidget {
  const RankScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingsAsyncValue = ref.watch(rankingsProvider);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            
            // 타이틀
            const Text(
              '행복 랭킹',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 18,
                color: Colors.amber,
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              '행복 기록을 많이 남긴 순위',
              style: TextStyle(
                fontFamily: 'NanumGothicCoding',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 랭킹 목록
            rankingsAsyncValue.when(
              data: (rankings) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: rankings.length,
                    itemBuilder: (context, index) {
                      final rank = index + 1;
                      final userData = rankings[index];
                      final isCurrentUser = userData['id'] == FirebaseService.currentUserId;
                      
                      return _buildRankItem(
                        context,
                        rank: rank,
                        nickname: userData['nickname'] ?? '익명',
                        recordCount: userData['recordCount'] ?? 0,
                        avatarLevel: _calculateAvatarLevel(userData['recordCount'] ?? 0),
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  ),
                );
              },
              loading: () => const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const Expanded(
                child: Center(child: Text('랭킹을 불러올 수 없습니다.')),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRankItem(
    BuildContext context, {
    required int rank,
    required String nickname,
    required int recordCount,
    required String avatarLevel,
    required bool isCurrentUser,
  }) {
    // 랭킹에 따른 아이콘과 색상
    Widget rankWidget;
    if (rank == 1) {
      rankWidget = const Icon(Icons.emoji_events, color: Colors.amber, size: 24);
    } else if (rank == 2) {
      rankWidget = const Icon(Icons.emoji_events, color: Colors.grey, size: 22);
    } else if (rank == 3) {
      rankWidget = const Icon(Icons.emoji_events, color: Colors.brown, size: 20);
    } else {
      rankWidget = Text(
        '$rank',
        style: const TextStyle(
          fontFamily: 'PressStart2P',
          fontSize: 12,
        ),
      );
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.amber.withOpacity(0.2) : Colors.grey.shade900,
        border: Border.all(
          color: isCurrentUser ? Colors.amber : Colors.white.withOpacity(0.3),
          width: isCurrentUser ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // 순위
          SizedBox(
            width: 36,
            child: Center(child: rankWidget),
          ),
          
          const SizedBox(width: 12),
          
          // 아바타
          PixelAvatar(
            size: 32,
            status: avatarLevel,
          ),
          
          const SizedBox(width: 12),
          
          // 닉네임 및 기록 수
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      nickname,
                      style: TextStyle(
                        fontFamily: 'NanumGothicCoding',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isCurrentUser ? Colors.amber : Colors.white,
                      ),
                    ),
                    if (isCurrentUser)
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 12,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '행복 기록 $recordCount회',
                  style: TextStyle(
                    fontFamily: 'NanumGothicCoding',
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          
          // 메달 또는 추가 정보
          if (rank <= 3)
            _buildMedalIcon(rank),
        ],
      ),
    );
  }
  
  Widget _buildMedalIcon(int rank) {
    IconData iconData;
    Color color;
    
    switch (rank) {
      case 1:
        iconData = Icons.looks_one;
        color = Colors.amber;
        break;
      case 2:
        iconData = Icons.looks_two;
        color = Colors.grey.shade300;
        break;
      case 3:
        iconData = Icons.looks_3;
        color = Colors.brown.shade300;
        break;
      default:
        iconData = Icons.emoji_events;
        color = Colors.white;
    }
    
    return Icon(
      iconData,
      color: color,
      size: 24,
    );
  }
  
  String _calculateAvatarLevel(int recordCount) {
    if (recordCount == 0) return 'neutral';
    if (recordCount <= 5) return 'happy';
    if (recordCount <= 10) return 'star';
    return 'glow';
  }
} 