import 'package:flutter/material.dart';

enum BubbleDirection {
  top,
  bottom,
  left,
  right,
}

class PixelSpeechBubble extends StatelessWidget {
  final String text;
  final BubbleDirection direction;
  final Color backgroundColor;
  final Color borderColor;
  final double width;
  final double fontSize;

  const PixelSpeechBubble({
    super.key,
    required this.text,
    this.direction = BubbleDirection.bottom,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.width = 200,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 메인 말풍선 몸체
        Container(
          width: width,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
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
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'PressStart2P',
              fontSize: fontSize,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // 말풍선 꼬리
        Positioned(
          bottom: direction == BubbleDirection.bottom ? -10 : null,
          top: direction == BubbleDirection.top ? -10 : null,
          left: direction == BubbleDirection.left ? -10 : 
                [BubbleDirection.top, BubbleDirection.bottom].contains(direction) ? width / 2 - 5 : null,
          right: direction == BubbleDirection.right ? -10 : null,
          child: _buildTail(),
        ),
      ],
    );
  }
  
  Widget _buildTail() {
    switch (direction) {
      case BubbleDirection.bottom:
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: const Border(
              left: BorderSide(color: Colors.black, width: 2),
              right: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        );
      case BubbleDirection.top:
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: const Border(
              left: BorderSide(color: Colors.black, width: 2),
              right: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        );
      case BubbleDirection.left:
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: const Border(
              top: BorderSide(color: Colors.black, width: 2),
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        );
      case BubbleDirection.right:
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: const Border(
              top: BorderSide(color: Colors.black, width: 2),
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        );
    }
  }
}

// 토스트 메시지 형태로 말풍선 표시
class PixelSpeechBubbleToast {
  static void show(
    BuildContext context, {
    required String message,
    BubbleDirection direction = BubbleDirection.top,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.7,
        left: MediaQuery.of(context).size.width / 2 - 100,
        child: Material(
          color: Colors.transparent,
          child: PixelSpeechBubble(
            text: message,
            direction: direction,
          ),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
} 