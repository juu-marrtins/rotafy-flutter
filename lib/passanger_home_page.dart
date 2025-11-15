import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rotafy/Widgets/passanger_or_driver.dart';
import 'package:rotafy/Widgets/search.dart';
import 'package:rotafy/Widgets/tool_circle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassangerHomePage extends StatefulWidget {
  const PassangerHomePage({super.key});

  @override
  State<PassangerHomePage> createState() => _PassangerHomePageState();
}

class _PassangerHomePageState extends State<PassangerHomePage> {
  List<dynamic> rides = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRides(); 
  }

  Future<void> _fetchRides({String? search}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('Token não encontrado');
      }

      final params = {
        'per_page': '15',
        'page': '1',
        'search': search ?? '',
      };

      final url = Uri.http('localhost:8000', '/api/races', params);

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          rides = json['data'];
        });
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Sessão expirada. Faça login novamente.';
        });
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        final errorBody = jsonDecode(response.body);
        errorMessage =
            'Erro ${response.statusCode}: ${errorBody['message'] ?? 'Erro desconhecido'}';
      }
    } catch (e) {
      errorMessage = 'Erro de conexão: $e';
    }
  }

  Future<void> _sendRaceRequest(int raceId, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token não encontrado")),
        );
        return;
      }

      final url = Uri.parse(
        "http://localhost:8000/api/request_race?race_id=$raceId",
      );

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body["message"] ?? "Solicitação enviada")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ${response.statusCode} ao solicitar corrida"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  ToolCircle(),
                  SizedBox(width: 20),
                  PassangerOrDriver(),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Search(
              onChanged: (text) {
                _fetchRides(search: text);
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  final ride = rides[index];
                  return _buildRideCard(ride);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride) {
    return Card(
      color: Color.fromARGB(207, 226, 232, 250),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Color.fromARGB(76, 29, 53, 87),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF1D3557),
                  child: Icon(Icons.person, color: Color(0xFFA8E63E)),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride['driver_name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      ride['driver_title'],
                      style: const TextStyle(color: Color(0xFF0B132B)),
                    ),
                    Text(
                      "R\$ ${ride['value']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1D3557),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              ride['origin'],
              style: const TextStyle(fontSize: 14, color: Color(0xFF0B132B)),
            ),
            const SizedBox(height: 4),
            Text(
              ride['destiny'],
              style: const TextStyle(fontSize: 14, color: Color(0xFF1D3557)),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saída: ${ride['departure_time']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Chegada: ${ride['arrival_time']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Vagas: ${ride['available_seats']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D3557),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _sendRaceRequest(ride['id'], context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1D3557),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Solicitar corrida",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
