import 'package:flutter/material.dart';

class DriverOrPassanger extends StatefulWidget {
  const DriverOrPassanger({super.key});

  @override
  State<DriverOrPassanger> createState() => _DriverOrPassangerState();
}

class _DriverOrPassangerState extends State<DriverOrPassanger> {
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
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
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
          Container(
            width: 115,
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
                  Icon(Icons.directions_car, color: Colors.black, size: 18),
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
        ],
      ),
    );
  }
}
