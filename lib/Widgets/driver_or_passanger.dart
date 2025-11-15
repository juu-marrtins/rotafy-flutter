import 'package:flutter/material.dart';
import 'package:rotafy/passanger_home_page.dart';

class DriverOrPassanger extends StatefulWidget {
  const DriverOrPassanger({super.key});

  @override
  State<DriverOrPassanger> createState() => _DriverOrPassangerState();
}

class _DriverOrPassangerState extends State<DriverOrPassanger> {
  bool isPassenger = true; 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() => isPassenger = true);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PassangerHomePage(),
                ),
              );
            },
            child: Container(
              width: 115,
              decoration: BoxDecoration(
                color: isPassenger ? Color(0xFF0B132B) :Color(0xFFA8E63E),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Text(
                  "Passageiro",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => isPassenger = false);
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_car, color: Color(0xFF0B132B), size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Motorista",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
