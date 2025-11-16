import 'package:flutter/material.dart';
import 'package:rotafy/login_page.dart';
import 'package:rotafy/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RotaFy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 85, 194, 85)),
      ),
      home: RegisterPage(),
    );
  }
}
