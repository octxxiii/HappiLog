import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happilog/components/pixel_avatar.dart';
import 'package:happilog/components/pixel_button.dart';
import 'package:happilog/components/pixel_speech_bubble.dart';
import 'package:happilog/providers/providers.dart';
import 'package:happilog/services/firebase_service.dart';

class AvatarScreen extends ConsumerStatefulWidget {
  const AvatarScreen({super.key});

  @override
  ConsumerState<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends ConsumerState<AvatarScreen> {
  final _nicknameController = TextEditingController();
  bool _isEditing = false;
  bool _isSaving = false;
  
  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }
  
  Future<void> _saveNickname() async {
    if (_nicknameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임을 입력해주세요.')),
      );
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      await FirebaseService.updateNickname(_nicknameController.text.trim());
      
      if (mounted) {
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });
        
        PixelSpeechBubbleToast.show(
          context,
          message: '닉네임이 변경되었습니다!',
          direction: BubbleDirection.top,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('닉네임 변경 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final avatarStatus = ref.watch(avatarStatusProvider);
    final userDataAsyncValue = ref.watch(userProvider);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            
            // 타이틀
            const Text(
              '나의 아바타',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 18,
                color: Colors.amber,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 아바타 및 상태 표시
            userDataAsyncValue.when(
              data: (userData) {
                final String nickname = userData?['nickname'] ?? '행복이';
                final int recordCount = userData?['recordCount'] ?? 0;
                
                if (!_isEditing) {
                  _nicknameController.text = nickname;
                }
                
                return Column(
                  children: [
                    // 아바타
                    const PixelAvatar(size: 180),
                    const SizedBox(height: 24),
                    
                    // 상태 표시
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getAvatarStatusText(avatarStatus, recordCount),
                        style: const TextStyle(
                          fontFamily: 'PressStart2P',
                          fontSize: 10,
                          color: Colors.amber,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 닉네임 및 편집
                    _isEditing
                        ? _buildNicknameEditForm()
                        : _buildNicknameDisplay(nickname),
                    
                    const SizedBox(height: 24),
                    
                    // 레벨 및 기록 정보
                    _buildLevelInfo(recordCount),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('사용자 정보를 불러올 수 없습니다.')),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNicknameDisplay(String nickname) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.face, size: 20),
        const SizedBox(width: 8),
        Text(
          nickname,
          style: const TextStyle(
            fontFamily: 'NanumGothicCoding',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            setState(() {
              _isEditing = true;
            });
          },
          child: const Icon(
            Icons.edit,
            size: 16,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
  
  Widget _buildNicknameEditForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: '닉네임',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: const TextStyle(
              fontFamily: 'NanumGothicCoding',
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _isSaving
            ? const CircularProgressIndicator(strokeWidth: 2)
            : InkWell(
                onTap: _saveNickname,
                child: const Icon(
                  Icons.check,
                  size: 24,
                  color: Colors.green,
                ),
              ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {
            setState(() {
              _isEditing = false;
            });
          },
          child: const Icon(
            Icons.close,
            size: 24,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
  
  Widget _buildLevelInfo(int recordCount) {
    return Column(
      children: [
        Text(
          '현재 기록 횟수: $recordCount',
          style: const TextStyle(
            fontFamily: 'NanumGothicCoding',
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        _buildProgressBar(recordCount),
        const SizedBox(height: 16),
        _buildNextLevelInfo(recordCount),
      ],
    );
  }
  
  Widget _buildProgressBar(int recordCount) {
    int targetCount = 0;
    int currentLevelCount = 0;
    
    if (recordCount <= 5) {
      targetCount = 5;
      currentLevelCount = recordCount;
    } else if (recordCount <= 10) {
      targetCount = 10;
      currentLevelCount = recordCount - 5;
    } else {
      targetCount = recordCount;
      currentLevelCount = recordCount;
    }
    
    final progress = currentLevelCount / targetCount;
    
    return Container(
      width: double.infinity,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8 * progress,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }
  
  Widget _buildNextLevelInfo(int recordCount) {
    String nextLevel = '';
    int remainingCount = 0;
    
    if (recordCount < 5) {
      nextLevel = '행복 아바타';
      remainingCount = 5 - recordCount;
    } else if (recordCount < 10) {
      nextLevel = '스타 아바타';
      remainingCount = 10 - recordCount;
    } else if (recordCount == 10) {
      nextLevel = '글로우 아바타';
      remainingCount = 1;
    } else {
      return const Text(
        '최고 레벨 달성! 행복 기록을 계속 이어가세요!',
        style: TextStyle(
          fontFamily: 'NanumGothicCoding',
          fontSize: 14,
          color: Colors.amber,
        ),
        textAlign: TextAlign.center,
      );
    }
    
    return Text(
      '다음 레벨 ($nextLevel)까지 $remainingCount회 남았습니다!',
      style: const TextStyle(
        fontFamily: 'NanumGothicCoding',
        fontSize: 14,
        color: Colors.amber,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  String _getAvatarStatusText(String status, int recordCount) {
    switch (status) {
      case 'neutral':
        return 'Lv.0 기본 아바타 (기록 없음)';
      case 'happy':
        return 'Lv.1 행복 아바타 ($recordCount/5)';
      case 'star':
        return 'Lv.2 스타 아바타 ($recordCount/10)';
      case 'glow':
        return 'Lv.MAX 글로우 아바타 (최고 레벨)';
      default:
        return '기본 아바타';
    }
  }
} 