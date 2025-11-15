import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rotafy/login_page.dart';
import 'package:rotafy/Widgets/combine_confirme_chegue.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String course = '';
  String ra = '';
  String phone = '';
  String user_type = '';
  String user_title = '';
  String cpf = '';
  String cnpj = '';

  Future<void> _sendToBackend() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/register'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},  
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'course': course,
          'ra': ra,
          'phone': phone,
          'user_type': user_type,
          'user_title': user_title,
          'cpf': cpf,
          'cnpj': cnpj,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado!')),
        );;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
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
          child: SingleChildScrollView(
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
                  decoration: const InputDecoration(labelText: "Nome completo"),
                  style: const TextStyle(color: Color(0xFF1D3557)),
                  onSaved: (value) => name = value ?? '',
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : "Campo obrigatório",
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: "E-mail"),
                  style: const TextStyle(color: Color(0xFF1D3557)),
                  onSaved: (value) => email = value ?? '',
                  validator: (value) =>
                      value != null && value.contains("@") ? null : "Digite um e-mail válido",
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Senha"),
                  style: const TextStyle(color: Color(0xFF1D3557)),
                  onSaved: (value) => password = value ?? '',
                  validator: (value) =>
                      value != null && value.length >= 6
                          ? null
                          : "Mínimo de 6 caracteres",
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Curso"),
                  style: const TextStyle(color: Color(0xFF1D3557)),
                  onSaved: (value) => course = value ?? '',
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : "Campo obrigatório",
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: "RA"),
                  style: const TextStyle(color: Color(0xFF1D3557)),
                  onSaved: (value) => ra = value ?? '',
                  validator: (value) =>
                      value != null && value.length >= 8
                          ? null
                          : "RA deve ter no mínimo 8 caracteres",
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Telefone"),
                  style: const TextStyle(color: Color(0xFF1D3557)),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => phone = value ?? '',
                  validator: (value) =>
                      value != null && value.length >= 10
                          ? null
                          : "Telefone inválido",
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Tipo de usuário"),
                  items: const [
                    DropdownMenuItem(value: "driver", child: Text("Motorista")),
                    DropdownMenuItem(value: "passenger", child: Text("Passageiro")),
                    DropdownMenuItem(value: "both", child: Text("Motorista e Passageiro")),
                  ],
                  onChanged: (value) {
                    user_type = value ?? '';
                  },
                  validator: (value) => value != null ? null : "Selecione uma opção",
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Vínculo institucional", 
                    fillColor: Colors.white,
                    ),
                  items: const [
                    DropdownMenuItem(value: "student", child: Text("Estudante")),
                    DropdownMenuItem(value: "teacher", child: Text("Professor")),
                    DropdownMenuItem(value: "employee", child: Text("Funcionário")),
                  ],
                  onChanged: (value) {
                    user_title = value ?? '';
                  },
                  validator: (value) => value != null ? null : "Selecione uma opção",
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: "CPF"),
                  style: const TextStyle(color: Color(0xFF1D3557)),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => cpf = value ?? '',
                  validator: (value) =>
                      value != null && value.length >= 11 ? null : "CPF inválido",
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: "CNPJ"),
                  style: const TextStyle(color: Color(0xFF1D3557)),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => cnpj = value ?? '',
                  validator: (value) =>
                      value != null && value.length >= 14 ? null : "CNPJ inválido",
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _sendToBackend();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D3557),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Cadastrar",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
