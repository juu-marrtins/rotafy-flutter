import 'package:flutter/material.dart';

class CombineConfirmeChegue extends StatelessWidget {
  const CombineConfirmeChegue({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: 'Combine. ',
            style: TextStyle(color: Color(0xFF1D3557)), 
          ),
          TextSpan(
            text: 'Confirme. ',
            style: TextStyle(color: Color(0xFF457B9D)),
          ),
          TextSpan(
            text: 'Chegue.',
            style: TextStyle(color: Color(0xFFA8E63E)),
          ),
        ],
      ),
    );
  }
}
