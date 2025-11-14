import 'package:flutter/material.dart';
import 'package:rotafy/driver_home_page.dart';

class PassangerOrDriver extends StatefulWidget {
  const PassangerOrDriver({super.key});

  @override
  State<PassangerOrDriver> createState() => _PassangerOrDriverState();
}

class _PassangerOrDriverState extends State<PassangerOrDriver> {
  bool isPassenger = true; 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF1D3557),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() => isPassenger = true);
            },
            child: Container(
              width: 115,
              decoration: BoxDecoration(
                color: isPassenger ? const Color(0xFF1D3557) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.front_hand,
                      color: isPassenger
                          ? const Color(0xFFA8E63E)
                          : const Color(0xFF1D3557),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Passageiro",
                      style: TextStyle(
                        color: isPassenger
                            ? const Color(0xFFA8E63E)
                            : const Color(0xFF1D3557),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => isPassenger = false);
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DriverHomePage(),
                  ),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Motorista",
                    style: TextStyle(
                      color: Color(0xFF1D3557),
                      fontWeight: FontWeight.bold,
                    ),
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
