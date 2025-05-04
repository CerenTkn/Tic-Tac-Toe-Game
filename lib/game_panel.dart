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
            title: const Text('Congratulations !!!'),
            content: Text('$currentPlayer won (+ 3 points)'),
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
                    // Winner başlar!
                  });
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
      else if (!board.contains('')) {
        // Draw
        // Draw
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Draw !!!'),
            content: const Text('One point for each player'),
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
                child: const Text('Ok'),
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
        title: const Text('Are you sure to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // No: sadece dialog kapanır
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog kapanır

              // kazananı kontrol et
              if (score1 == score2) {
                // berabereyse kimse eklenmesin
                Navigator.pop(context);
                return;
              }

              String winnerName;
              String winnerSymbol;
              int winnerScore;

              if (score1 > score2) {
                winnerName = widget.player1;
                winnerSymbol = 'X';
                winnerScore = score1;
              } else {
                winnerName = widget.player2;
                winnerSymbol = 'O';
                winnerScore = score2;
              }

              String heroEntry = '$winnerName ($winnerSymbol) - $winnerScore';
              Navigator.pop(context, heroEntry);
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
      backgroundColor: const Color(0xFFEFF6E0),
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Game Panel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Skorlar
            Column(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Player 1 Score: ',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$score1',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Player 2 Score: ',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$score2',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(thickness: 1, color: Colors.black45),

            const SizedBox(height: 8),
            // Round bilgisi
            Text(
              'Round: $round',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),
            // Turn bilgisi
            Align(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  text: 'Turn: ',
                  style: const TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: '$currentPlayer ($currentSymbol)',
                      style: TextStyle(
                        color: currentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 12),

            // Oyun alanı
            Expanded(
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => handleTap(index),
                    child: Container(
                      margin: const EdgeInsets.all(2),
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

            const SizedBox(height: 12),

            // Butonlar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: resetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: confirmExit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Exit', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
