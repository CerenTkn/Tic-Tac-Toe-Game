import 'package:flutter/material.dart';
import 'players_info.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6E0), // Açık yeşil arka plan
      appBar: AppBar(
        title: const Text('Welcome to TTT'),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // XOX görseli + Tic Tac Toe yazısı üst üste
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/background.png',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/images/words.png',
                width: 150,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Turuncu daire içindeki V1.0
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: const Text(
              'V 1.0',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Continue >> butonu
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlayersInfoPage(),
                ),
              );
            },
            child: const Text(
              'Continue >>',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
