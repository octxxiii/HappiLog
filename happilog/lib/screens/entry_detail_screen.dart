import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:happilog/components/pixel_button.dart';
import 'package:happilog/models/daily_record.dart';
import 'package:happilog/services/firebase_service.dart';
import 'package:intl/intl.dart';

class EntryDetailScreen extends ConsumerStatefulWidget {
  final String recordId;

  const EntryDetailScreen({
    super.key,
    required this.recordId,
  });

  @override
  ConsumerState<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends ConsumerState<EntryDetailScreen> {
  DailyRecord? _record;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadRecord();
  }
  
  Future<void> _loadRecord() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final record = await FirebaseService.getRecord(widget.recordId);
      
      if (mounted) {
        setState(() {
          _record = record;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('기록을 불러올 수 없습니다: $e')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_record == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('기록 없음'),
        ),
        body: const Center(
          child: Text('해당 기록을 찾을 수 없습니다.'),
        ),
      );
    }
    
    final dateFormatter = DateFormat('yyyy년 MM월 dd일');
    final dateStr = dateFormatter.format(_record!.date);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '행복 기록',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 및 감정
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getEmotionColor(_record!.emotion),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 12,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 이미지
            if (_record!.imageUrl != null) ...[
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: _record!.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // 내용
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _record!.text,
                style: const TextStyle(
                  fontFamily: 'NanumGothicCoding',
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 돌아가기 버튼
            Center(
              child: PixelButton(
                text: '돌아가기',
                onPressed: () {
                  context.go('/');
                },
                width: 140,
              ),
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
} 