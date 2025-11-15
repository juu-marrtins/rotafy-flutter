import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final Function(String) onChanged;

  const Search({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.white, 
        decoration: InputDecoration(
          filled: true, 
          fillColor: const Color(0xFF1D3557),
          hint: Stack(
            children: [
              Text(
                'Procurar',
                style: TextStyle(
                  fontSize: 16,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Color(0xFF0B132B),
                ),
              ),
              const Text(
                'Procurar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          suffixIcon: const Icon(Icons.search, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none, 
          ),
        ),
        style: const TextStyle(color: Colors.white), 
      ),
    );
  }
}
