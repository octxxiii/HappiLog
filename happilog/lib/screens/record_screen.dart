import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:happilog/components/pixel_button.dart';
import 'package:happilog/components/pixel_speech_bubble.dart';
import 'package:happilog/models/daily_record.dart';
import 'package:happilog/services/firebase_service.dart';
import 'package:image_picker/image_picker.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  final _textController = TextEditingController();
  File? _selectedImage;
  Emotion _selectedEmotion = Emotion.happy;
  bool _isLoading = false;
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 선택할 수 없습니다.')),
      );
    }
  }
  
  Future<void> _saveRecord() async {
    // 입력 유효성 검사
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내용을 입력해주세요.')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      String? imageUrl;
      
      // 이미지가 있으면 업로드
      if (_selectedImage != null) {
        imageUrl = await FirebaseService.uploadImage(_selectedImage!);
      }
      
      // 기록 생성 및 저장
      final record = DailyRecord(
        text: _textController.text.trim(),
        imageUrl: imageUrl,
        emotion: _selectedEmotion,
        date: DateTime.now(),
      );
      
      await FirebaseService.saveRecord(record);
      
      if (mounted) {
        // 토스트 메시지 표시
        PixelSpeechBubbleToast.show(
          context,
          message: '행복이 기록되었습니다!',
          direction: BubbleDirection.top,
        );
        
        // 2초 후 홈으로 이동
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.go('/');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('기록 저장 중 오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            
            // 타이틀
            const Text(
              '오늘의 행복 기록하기',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 16,
                color: Colors.amber,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 이미지 선택 영역
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 48,
                            color: Colors.white70,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '이미지 선택 (선택사항)',
                            style: TextStyle(
                              fontFamily: 'NanumGothicCoding',
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 감정 선택기
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '오늘의 감정:',
                  style: TextStyle(
                    fontFamily: 'NanumGothicCoding',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 16),
                _buildEmotionSelector(Emotion.happy, '행복'),
                const SizedBox(width: 8),
                _buildEmotionSelector(Emotion.neutral, '보통'),
                const SizedBox(width: 8),
                _buildEmotionSelector(Emotion.sad, '슬픔'),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 텍스트 입력
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: TextField(
                controller: _textController,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: '오늘 있었던 행복한 일을 기록해보세요.',
                  hintStyle: TextStyle(
                    fontFamily: 'NanumGothicCoding',
                    color: Colors.white38,
                  ),
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontFamily: 'NanumGothicCoding',
                  fontSize: 16,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 저장 버튼
            _isLoading
                ? const CircularProgressIndicator()
                : PixelButton(
                    text: '기록 저장하기',
                    onPressed: _saveRecord,
                    width: 180,
                  ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmotionSelector(Emotion emotion, String label) {
    final isSelected = _selectedEmotion == emotion;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEmotion = emotion;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _getEmotionColor(emotion) : Colors.transparent,
          border: Border.all(
            color: _getEmotionColor(emotion),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'NanumGothicCoding',
            fontSize: 14,
            color: isSelected 
                ? (emotion == Emotion.happy ? Colors.black : Colors.white) 
                : _getEmotionColor(emotion),
          ),
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
} 