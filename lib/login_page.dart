import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rotafy/Widgets/combine_confirme_chegue.dart';
import 'package:rotafy/passanger_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool loading = false;

  Future<void> _sendToBackend() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data']['token'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login bem-sucedido!')),
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        await Future.delayed(const Duration(seconds: 1));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PassangerHomePage(),
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${error['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logo_rotafy.jpg',
                width: 162,
                height: 162,
              ),
              const SizedBox(height: 20),
              const CombineConfirmeChegue(),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: "E-mail"),
                style: const TextStyle(color: Color(0xFF1D3557)),
                onSaved: (value) => email = value ?? '',
                validator: (value) =>
                    value != null && value.contains("@")
                        ? null
                        : "Digite um e-mail válido",
              ),

              const SizedBox(height: 16),

              TextFormField(
                obscureText: true,
                style: const TextStyle(color: Color(0xFF1D3557)),
                decoration: const InputDecoration(labelText: "Senha"),
                onSaved: (value) => password = value ?? '',
                validator: (value) =>
                    value != null && value.length >= 6
                        ? null
                        : "Mínimo de 6 caracteres",
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _sendToBackend();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(29, 53, 87, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
