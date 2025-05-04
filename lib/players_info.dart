import 'package:flutter/material.dart';
import 'game_panel.dart';

class PlayersInfoPage extends StatefulWidget {
  const PlayersInfoPage({super.key});

  @override
  State<PlayersInfoPage> createState() => _PlayersInfoPageState();
}

class _PlayersInfoPageState extends State<PlayersInfoPage> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  List<String> heroes = [];

  void swapPlayers() {
    setState(() {
      final temp = player1Controller.text;
      player1Controller.text = player2Controller.text;
      player2Controller.text = temp;
    });
  }

  Future<void> navigateToGame() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePanelPage(
          player1: player1Controller.text.isEmpty ? 'Player 1' : player1Controller.text,
          player2: player2Controller.text.isEmpty ? 'Player 2' : player2Controller.text,
        ),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        heroes.add(result);
      });
    }
  }

  Widget buildPlayerCard(TextEditingController controller, Color color, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // TOP DEĞİL, ORTALA
        children: [
          // Gri kutu içindeki kişi ikonu
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.person, size: 18, color: Colors.black54),
          ),
          const SizedBox(width: 12),

          // TextField + altında etiket yazısı
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),

          // Büyük ve ortalanmış renkli daire
          CircleAvatar(
            backgroundColor: color,
            radius: 16, // büyütüldü!
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6E0),
      appBar: AppBar(
        title: const Text('Players Panel'),
        backgroundColor: Colors.lightGreen,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Divider(thickness: 1, color: Colors.black), // üst çizgi

            buildPlayerCard(player1Controller, Colors.blue, 'Player 1'),

            const SizedBox(height: 4),

            const Icon(Icons.unfold_more, size: 30, color: Colors.black), // Dikey çift ok

            const SizedBox(height: 4),

            buildPlayerCard(player2Controller, Colors.red, 'Player 2'),

            const Divider(thickness: 1, color: Colors.black), // alt çizgi

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.center,
              child: Text(
                'Heros List:',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'monospace',
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child : ListView.builder(
                itemCount: heroes.length,
                itemBuilder: (context, index) {
                  final entry = heroes[index];

                  // Örn: "Player 1 (X) - 4"
                  String name = '';
                  String symbol = '';
                  String score = '';

                  try {
                    final regex = RegExp(r'^(.*?)\s+\((.*?)\)\s*-\s*(\d+)$');
                    final match = regex.firstMatch(entry);
                    if (match != null) {
                      name = match.group(1)!;
                      symbol = match.group(2)!;
                      score = match.group(3)!;
                    } else {
                      name = entry; // fallback
                    }
                  } catch (e) {
                    name = entry; // fallback
                  }

                  return Dismissible(
                    key: Key(entry + index.toString()),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_) {
                      setState(() {
                        heroes.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 28),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                symbol,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: symbol == 'X'
                                      ? Colors.blue
                                      : (symbol == 'O' ? Colors.red : Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            score,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: navigateToGame,
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
