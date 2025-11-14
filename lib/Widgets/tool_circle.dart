import 'package:flutter/material.dart';

class ToolCircle extends StatelessWidget {
  const ToolCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1D3557),
              border: Border.fromBorderSide(
                BorderSide(color: Colors.white),
              ),
            ),
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
