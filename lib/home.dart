import 'package:flutter/material.dart';
import 'players_info.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6E0),
      appBar: AppBar(
        title: const Text('Welcome to TTT'),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Görsel Stack
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/background.png',
                    width: size.width * 0.95,
                    height: size.width * 0.95,
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'assets/images/words.png',
                    width: size.width * 0.6,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // V1.0 yuvarlak buton
            // Büyük yuvarlak turuncu V1.0
            Container(
              padding: const EdgeInsets.all(24), // büyütüldü
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: const Text(
                'V 1.0',
                style: TextStyle(
                  fontSize: 24, // büyütüldü
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Continue butonu
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
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
