import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'players_info.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF689F38),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: const Color(0xFFEFF6E0),
        appBar: AppBar(
          title: const Text('Welcome to TTT'),
          backgroundColor: Colors.lightGreen,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/background.png',
                        width: size.width * 0.97,
                        height: size.width * 0.97,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/images/words.png',
                        width: size.width * 0.3,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(
              bottom: size.height * 0.2,
              left: (size.width - 80) / 2,
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'V 1.0',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Continue button
            Positioned(
              bottom: size.height * 0.06,
              left: (size.width - 160) / 2,
              child: TextButton(
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
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
