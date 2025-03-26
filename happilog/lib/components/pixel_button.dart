import 'package:flutter/material.dart';

class PixelButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double width;
  final double height;
  final bool isDisabled;

  const PixelButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.width = 160,
    this.height = 40,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).colorScheme.primary;
    final buttonTextColor = textColor ?? Colors.black;

    return InkWell(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey : buttonColor,
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              text,
              style: TextStyle(
                color: isDisabled ? Colors.white.withOpacity(0.7) : buttonTextColor,
                fontFamily: 'PressStart2P',
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 