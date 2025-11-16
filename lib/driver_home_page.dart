import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rotafy/Widgets/driver_or_passanger.dart';
import 'package:rotafy/Widgets/passanger_or_driver.dart';
import 'package:rotafy/Widgets/search.dart';
import 'package:rotafy/Widgets/tool_circle.dart';
import 'package:rotafy/create_race.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
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

      final url = Uri.parse('http://localhost:8000/api/driver/races').replace(
        queryParameters: {
          'per_page': '15',
          'page': '1',
          'search': search ?? '',        
        },
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        setState(() {
          rides = jsonResponse['data'];
        });
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = "Sessão expirada. Faça login novamente.";
        });
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        setState(() {
          errorMessage = "Erro ao carregar: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Erro de conexão: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                  children: [
                    const ToolCircle(),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DriverOrPassanger(),
                    ),
                  ],
                )
            ),
            const SizedBox(height: 25),
            Search(
              onChanged: (text) {
                _fetchRides(search: text);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Corridas"),
                    const Text(
                      "Mais Recentes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: errorMessage != null
                          ? Center(child: Text(errorMessage!))
                          : ListView.builder(
                              itemCount: rides.length,
                              itemBuilder: (context, index) {
                                final ride = rides[index];
                                return _rideItem(ride);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child:
                        _bottomButton("Excluir", Colors.white, Colors.black),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _bottomButton(
                        "Editar", const Color(0xFFA8E63E), Colors.white),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                  backgroundColor: const Color(0xFFA8E63E),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateRace()),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.black),
                ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _rideItem(dynamic ride) {
    final passengers = ride["passengers"] as List;

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Corrida #${ride['id']}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 200, 224, 230),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ride["status"],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text("Origem: ${ride['origin_id']}"),
          Text("Destino: ${ride['destination_id']}"),

          const SizedBox(height: 6),

          Row(children: [
            const Icon(Icons.schedule, size: 16),
            const SizedBox(width: 6),
            Text("Saída: ${ride['departure_time']}"),
          ]),
          Row(children: [
            const Icon(Icons.flag, size: 16),
            const SizedBox(width: 6),
            Text("Chegada: ${ride['arrival_time']}"),
          ]),

          const SizedBox(height: 8),

          Text(
            "Vagas disponíveis: ${ride['available_seats']}",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          const Divider(height: 20),

          const Text("Passageiros:", style: TextStyle(fontSize: 13)),
          const SizedBox(height: 4),

          if (passengers.isEmpty)
            const Text("Nenhum passageiro",
                style: TextStyle(fontSize: 12, color: Colors.grey))
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: passengers.map((p) {
                return Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "- ${p['user']['name']} (${p['user']['title']})",
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _bottomButton(String text, Color bg, Color fg) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
