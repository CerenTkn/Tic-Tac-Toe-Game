import 'package:flutter/material.dart';
import 'game_panel.dart';

class PlayersInfoPage extends StatefulWidget {
  const PlayersInfoPage({super.key});

  @override
  State<PlayersInfoPage> createState() => _PlayersInfoPageState();
}

class _PlayersInfoPageState extends State<PlayersInfoPage> {
  String player1 = 'Player 1';
  String player2 = 'Player 2';
  final List<String> heroes = []; // Kazananlar burada listelenecek

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  void swapPlayers() {
    setState(() {
      final temp = player1;
      player1 = player2;
      player2 = temp;
    });
  }

  void updatePlayerNames() {
    setState(() {
      if (controller1.text.isNotEmpty) player1 = controller1.text;
      if (controller2.text.isNotEmpty) player2 = controller2.text;
    });
  }

  Future<void> goToGamePanel() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePanelPage(
          player1: player1,
          player2: player2,
        ),
      ),
    );

    // Sonuç varsa kahraman listesine ekle
    if (result != null && result is String) {
      setState(() {
        heroes.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players Info'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Player 1 Card
            GestureDetector(
              onTap: () => _showNameDialog(controller1, 1),
              child: Card(
                child: ListTile(
                  title: Text(player1),
                  subtitle: const Text('Tap to edit name'),
                ),
              ),
            ),

            // Swap IconButton
            IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: swapPlayers,
            ),

            // Player 2 Card
            GestureDetector(
              onTap: () => _showNameDialog(controller2, 2),
              child: Card(
                child: ListTile(
                  title: Text(player2),
                  subtitle: const Text('Tap to edit name'),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text('Heroes List:'),
            const SizedBox(height: 10),

            // Heroes List
            Expanded(
              child: heroes.isEmpty
                  ? const Text('No heroes yet.')
                  : ListView.builder(
                itemCount: heroes.length,
                itemBuilder: (context, index) {
                  final hero = heroes[index];
                  return Dismissible(
                    key: Key(hero + index.toString()),
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
                    child: ListTile(title: Text(hero)),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button →
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
        onPressed: () {
          updatePlayerNames();
          goToGamePanel();
        },
      ),
    );
  }

  void _showNameDialog(TextEditingController controller, int playerNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter name for Player $playerNumber'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              updatePlayerNames();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
