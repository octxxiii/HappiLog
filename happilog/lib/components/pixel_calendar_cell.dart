import 'package:flutter/material.dart';

class PixelCalendarCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool hasRecord;
  final bool isToday;
  final bool isCurrentMonth;
  final VoidCallback onTap;
  final double size;

  const PixelCalendarCell({
    super.key,
    required this.date,
    required this.isSelected,
    required this.hasRecord,
    required this.isToday,
    required this.isCurrentMonth,
    required this.onTap,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isCurrentMonth 
        ? Colors.white
        : Colors.white.withOpacity(0.4);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3) 
              : Colors.transparent,
          border: Border.all(
            color: isToday 
                ? Theme.of(context).colorScheme.primary
                : isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
            width: isToday || isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // 날짜 표시
            Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'PressStart2P',
                  fontSize: 10,
                ),
              ),
            ),
            
            // 기록이 있는 날짜는 하트 아이콘 표시
            if (hasRecord)
              Positioned(
                bottom: 2,
                right: 2,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red.shade300,
                  size: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
} 