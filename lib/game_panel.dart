import 'package:flutter/material.dart';

class GamePanelPage extends StatefulWidget {
  final String player1;
  final String player2;

  const GamePanelPage({
    super.key,
    required this.player1,
    required this.player2,
  });

  @override
  State<GamePanelPage> createState() => _GamePanelPageState();
}

class _GamePanelPageState extends State<GamePanelPage> {
  List<String> board = List.filled(9, '');
  bool isPlayer1Turn = true;
  int round = 1;
  int score1 = 0;
  int score2 = 0;

  String get currentPlayer => isPlayer1Turn ? widget.player1 : widget.player2;
  String get currentSymbol => isPlayer1Turn ? 'X' : 'O';
  Color get currentColor => isPlayer1Turn ? Colors.blue : Colors.red;

  void resetBoard() {
    setState(() {
      board = List.filled(9, '');
    });
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      score1 = 0;
      score2 = 0;
      round = 1;
      isPlayer1Turn = true;
    });
  }

  void handleTap(int index) {
    if (board[index] != '') return;

    setState(() {
      board[index] = currentSymbol;

      if (checkWinner(currentSymbol)) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('$currentPlayer Wins!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    if (isPlayer1Turn) {
                      score1 += 3;
                    } else {
                      score2 += 3;
                    }
                    round++;
                    board = List.filled(9, '');
                    // winner starts again
                  });
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (!board.contains('')) {
        // Draw
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Draw!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    score1 += 1;
                    score2 += 1;
                    round++;
                    board = List.filled(9, '');
                    isPlayer1Turn = true;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        isPlayer1Turn = !isPlayer1Turn;
      }
    });
  }

  bool checkWinner(String symbol) {
    List<List<int>> lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in lines) {
      if (board[line[0]] == symbol &&
          board[line[1]] == symbol &&
          board[line[2]] == symbol) {
        return true;
      }
    }
    return false;
  }

  void confirmExit() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Exit Game?'),
        content: const Text('Do you want to exit and return winner info?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // No
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              String winnerName = score1 > score2 ? widget.player1 : widget.player2;
              String winnerSymbol = score1 > score2 ? 'X' : 'O';
              int winnerScore = score1 > score2 ? score1 : score2;

              String heroEntry = '$winnerName ($winnerSymbol) - $winnerScore';
              Navigator.pop(context, heroEntry); // Go back to players_info.dart
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Round: $round', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${widget.player1}: $score1', style: const TextStyle(fontSize: 18, color: Colors.blue)),
                Text('${widget.player2}: $score2', style: const TextStyle(fontSize: 18, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 20),

            // 3x3 Board
            Expanded(
              child: GridView.builder(
                itemCount: 9,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => handleTap(index),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: TextStyle(
                            fontSize: 40,
                            color: board[index] == 'X' ? Colors.blue : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Reset ve Exit Butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: resetGame,
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: confirmExit,
                  child: const Text('Exit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
