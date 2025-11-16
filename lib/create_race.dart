import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateRace extends StatefulWidget {
  const CreateRace({super.key});

  @override
  State<CreateRace> createState() => _CreateRaceState();
}

class _CreateRaceState extends State<CreateRace> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String originStreet = "";
  String originNumber = "";
  String originDistrict = "";
  String originCity = "";
  String originState = "";

  String destStreet = "";
  String destNumber = "";
  String destDistrict = "";
  String destCity = "";
  String destState = "";

  int availableSeats = 1;
  double suggestedValue = 0;

  DateTime? departureTime;
  DateTime? arrivalTime;

  String? formatDate(DateTime? dt) {
    if (dt == null) return null;
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} "
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:00";
  }

  Future<void> pickTime(bool isDeparture) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final dt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isDeparture) {
        departureTime = dt;
      } else {
        arrivalTime = dt;
      }
    });
  }

  Future<void> _sendToBackend() async {
    try {
      setState(() => loading = true);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Token não encontrado")));
        return;
      }

      final response = await http.post(
        Uri.parse("http://localhost:8000/api/create-race"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "origin_street": originStreet,
          "origin_number": originNumber,
          "origin_district": originDistrict,
          "origin_city": originCity,
          "origin_state": originState,
          "destination_street": destStreet,
          "destination_number": destNumber,
          "destination_district": destDistrict,
          "destination_city": destCity,
          "destination_state": destState,
          "arrival_time": formatDate(arrivalTime),
          "departure_time": formatDate(departureTime),
          "available_seats": availableSeats.toString(),
          "suggested_value": suggestedValue,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Corrida criada com sucesso!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body["message"] ?? "Erro ao criar corrida")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  Widget buildField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: type,
      style: const TextStyle(color: Color.fromARGB(255, 162, 184, 216)),
      onSaved: onSaved,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,

            child: ListView(
              children: [
                const Text(
                  "Criar Corrida",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Origem",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 12),
                buildField(
                  label: "Rua",
                  onSaved: (v) => originStreet = v ?? "",
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : "Campo obrigatório",
                ),
                buildField(
                  label: "Número",
                  type: TextInputType.number,
                  onSaved: (v) => originNumber = v ?? "",
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : "Campo obrigatório",
                ),
                buildField(
                  label: "Bairro",
                  onSaved: (v) => originDistrict = v ?? "",
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : "Campo obrigatório",
                ),
                buildField(
                  label: "Cidade",
                  onSaved: (v) => originCity = v ?? "",
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : "Campo obrigatório",
                ),
                buildField(
                  label: "Estado (UF)",
                  onSaved: (v) => originState = v ?? "",
                  validator: (v) =>
                      v != null && v.length == 2 ? null : "Ex: PR",
                ),
                const SizedBox(height: 30),
                const Text(
                  "Destino",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 12),
                buildField(
                  label: "Rua",
                  onSaved: (v) => destStreet = v ?? "",
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : "Campo obrigatório",
                ),
                buildField(
                  label: "Número",
                  type: TextInputType.number,
                  onSaved: (v) => destNumber = v ?? "",
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : "Campo obrigatório",
                ),
                buildField(
                  label: "Bairro",
                  onSaved: (v) => destDistrict = v ?? "",
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : "Campo obrigatório",
                ),
                buildField(
                  label: "Cidade",
                  onSaved: (v) => destCity = v ?? "",
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : "Campo obrigatório",
                ),
                buildField(
                  label: "Estado (UF)",
                  onSaved: (v) => destState = v ?? "",
                  validator: (v) =>
                      v != null && v.length == 2 ? null : "Ex: PR",
                ),
                const SizedBox(height: 30),
                const Text(
                  "Horários",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => pickTime(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA8E63E),
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    departureTime == null
                        ? "Selecionar saída"
                        : "Saída: ${formatDate(departureTime)}",
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => pickTime(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA8E63E),
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    arrivalTime == null
                        ? "Selecionar chegada"
                        : "Chegada: ${formatDate(arrivalTime)}",
                  ),
                ),
                const SizedBox(height: 30),
                buildField(
                  label: "Assentos disponíveis",
                  type: TextInputType.number,
                  onSaved: (v) => availableSeats = int.tryParse(v ?? "1") ?? 1,
                  validator: (v) => v != null && int.tryParse(v) != null
                      ? null
                      : "Digite um número",
                ),
                const SizedBox(height: 15),
                buildField(
                  label: "Valor sugerido (R\$)",
                  type: TextInputType.number,
                  onSaved: (v) =>
                      suggestedValue = double.tryParse(v ?? "0") ?? 0,
                  validator: (v) => v != null && double.tryParse(v) != null
                      ? null
                      : "Digite um valor válido",
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: loading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _sendToBackend();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA8E63E),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("Criar Corrida", style: TextStyle(fontSize: 18)),
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
