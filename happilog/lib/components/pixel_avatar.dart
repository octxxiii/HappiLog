import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happilog/providers/providers.dart';

class PixelAvatar extends ConsumerWidget {
  final double size;
  final String? status;

  const PixelAvatar({
    super.key,
    this.size = 128,
    this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarStatus = status ?? ref.watch(avatarStatusProvider);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 기본 아바타 모양
          Positioned.fill(
            child: _buildAvatarForStatus(avatarStatus ?? 'neutral'),
          ),
          
          // 글로우 효과 (glow 상태에만 표시)
          if (avatarStatus == 'glow')
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.7),
                    width: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildAvatarForStatus(String status) {
    // 실제 앱에서는 이미지 파일을 사용해야 합니다.
    // 현재는 색상으로 상태 구분
    switch (status) {
      case 'neutral':
        return _buildAvatar(Colors.blue.shade300);
      case 'happy':
        return _buildAvatar(Colors.green.shade300);
      case 'star':
        return _buildAvatar(Colors.amber.shade300);
      case 'glow':
        return _buildAvatar(Colors.orange.shade300);
      default:
        return _buildAvatar(Colors.blue.shade300);
    }
  }
  
  Widget _buildAvatar(Color color) {
    return CustomPaint(
      painter: PixelAvatarPainter(color),
    );
  }
}

class PixelAvatarPainter extends CustomPainter {
  final Color color;
  
  PixelAvatarPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    // 얼굴
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.25, size.height * 0.25, 
                    size.width * 0.5, size.height * 0.5),
      paint,
    );
    
    // 눈
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
      
    // 왼쪽 눈
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.4, 
                    size.width * 0.1, size.height * 0.1),
      eyePaint,
    );
    
    // 오른쪽 눈
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.55, size.height * 0.4, 
                    size.width * 0.1, size.height * 0.1),
      eyePaint,
    );
    
    // 입
    final mouthPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
      
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.6, 
                    size.width * 0.3, size.height * 0.05),
      mouthPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
} 