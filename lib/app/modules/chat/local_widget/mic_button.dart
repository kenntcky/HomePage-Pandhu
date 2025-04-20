import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MicButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onPressed;

  const MicButton({
    Key? key,
    required this.isListening,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: ShapeDecoration(
          color: isListening ? Colors.red : const Color(0xFFF6643C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(58),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isListening
            ? Lottie.asset(
                'asset/animations/mic_wave.json',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              )
            : const Icon(
                Icons.mic,
                color: Colors.white,
                size: 24,
              ),
        ),
      ),
    );
  }
} 