import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainMenuScreen(),
  ),
  );
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5C4033),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ultimate Tic-Tac-Toe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            _MenuButton(
              text: 'VS AI',
              onPressed: () => _startGame(context, vsAI: true),
            ),
            SizedBox(height: 20),
            _MenuButton(
              text: 'VS Player',
              onPressed: () => _startGame(context, vsAI: false),
            ),
            SizedBox(height: 20),
            _MenuButton(
              text: 'How to Play',
              onPressed: () => _showRules(context),
            ),
          ],
        ),
      ),
    );
  }

  void _startGame(BuildContext context, {required bool vsAI}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(vsAI: vsAI),
      ),
    );
  }

  void _showRules(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _RulesDialog(),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _MenuButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF8B4513),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xFFDEB887), width: 2),
        ),
        elevation: 8,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final bool vsAI;

  const GameScreen({super.key, required this.vsAI});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List<String>> cells = List.generate(9, (_) => List.filled(9, ''));
  List<String> sectionOwners = List.filled(9, '');
  int currentPlayer = 0;
  int? targetSection;
  bool gameOver = false;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    targetSection = null;
  }

  void _makeMove(int section, int cell) {
    if (gameOver || sectionOwners[section] != '' || cells[section][cell] != '') return;

    setState(() {
      cells[section][cell] = currentPlayer == 0 ? 'X' : 'O';
    });

    _checkSectionWin(section);
    _checkMainWin();

    if (!gameOver) {
      int nextTarget = cell;
      bool isNextTargetPlayable = sectionOwners[nextTarget] == '' && cells[nextTarget].contains('');

      setState(() {
        targetSection = isNextTargetPlayable ? nextTarget : null;
        currentPlayer = (currentPlayer + 1) % 2;
      });

      if (widget.vsAI && currentPlayer == 1) _aiMove();
    }
  }

  void _aiMove() {
    Future.delayed(Duration(milliseconds: 500), () {
      List<int> available = [];
      
      if (targetSection != null && sectionOwners[targetSection!] == '') {
        for (int c = 0; c < 9; c++) {
          if (cells[targetSection!][c] == '') {
            available.add(targetSection! * 10 + c);
          }
        }
      }

      if (available.isEmpty) {
        for (int s = 0; s < 9; s++) {
          if (sectionOwners[s] == '') {
            for (int c = 0; c < 9; c++) {
              if (cells[s][c] == '') available.add(s * 10 + c);
            }
          }
        }
      }

      if (available.isNotEmpty) {
        int move = available[random.nextInt(available.length)];
        _makeMove(move ~/ 10, move % 10);
      }
    });
  }

  void _checkSectionWin(int section) {
    List<List<int>> winPatterns = [
      [0,1,2], [3,4,5], [6,7,8],
      [0,3,6], [1,4,7], [2,5,8],
      [0,4,8], [2,4,6]
    ];

    for (var pattern in winPatterns) {
      if (cells[section][pattern[0]] != '' &&
          cells[section][pattern[0]] == cells[section][pattern[1]] &&
          cells[section][pattern[0]] == cells[section][pattern[2]]) {
        setState(() => sectionOwners[section] = cells[section][pattern[0]]);
        return;
      }
    }

    if (!cells[section].contains('')) {
      setState(() => sectionOwners[section] = 'D');
    }
  }

  void _checkMainWin() {
    List<List<int>> winPatterns = [
      [0,1,2], [3,4,5], [6,7,8],
      [0,3,6], [1,4,7], [2,5,8],
      [0,4,8], [2,4,6]
    ];

    for (var pattern in winPatterns) {
      String a = sectionOwners[pattern[0]];
      String b = sectionOwners[pattern[1]];
      String c = sectionOwners[pattern[2]];
      
      if (a != '' && a != 'D' && a == b && a == c) {
        _showGameOver(a == 'X' ? 'Player X Wins!' : widget.vsAI ? 'AI Wins!' : 'Player O Wins!');
        return;
      }
    }

    if (sectionOwners.every((s) => s != '') && !gameOver) {
      _showGameOver('Draw!');
    }
  }

  void _showGameOver(String message) {
    setState(() => gameOver = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _GameOverDialog(message: message, resetGame: _resetGame),
    );
  }

  void _resetGame() {
    setState(() {
      cells = List.generate(9, (_) => List.filled(9, ''));
      sectionOwners = List.filled(9, '');
      currentPlayer = 0;
      targetSection = null;
      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8B4513),
      appBar: AppBar(
        backgroundColor: Color(0xFF5C4033),
        title: Text(
          widget.vsAI ? 'VS AI' : 'VS Player',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _resetGame,
            backgroundColor: Color(0xFFDEB887),
            child: Icon(Icons.refresh, color: Color(0xFF5C4033)),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => _RulesDialog(),
            ),
            backgroundColor: Color(0xFFDEB887),
            child: Icon(Icons.help_outline, color: Color(0xFF5C4033)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: 9,
          itemBuilder: (context, section) {
            return _buildSection(section);
          },
        ),
      ),
    );
  }

  Widget _buildSection(int section) {
    String owner = sectionOwners[section];
    bool isLocked = owner != '';
    bool isActive = !isLocked && (targetSection == null || section == targetSection);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF5C4033), width: 4),
            color: _getSectionColor(owner),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView.builder(
            padding: EdgeInsets.all(4),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: 9,
            itemBuilder: (context, cell) {
              return _buildCell(section, cell, isLocked, isActive);
            },
          ),
        ),
        if (owner == 'X' || owner == 'O')
          Center(
            child: Text(
              owner,
              style: TextStyle(
                fontSize: 64,
                color: owner == 'X' ? Colors.red : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
      ],
    );
  }

  Color _getSectionColor(String owner) {
    if (owner == 'D') return Colors.grey.withValues(alpha: 0.4);
    return Color(0xFFDEB887);
  }

  Widget _buildCell(int section, int cell, bool isSectionLocked, bool isSectionActive) {
    String symbol = cells[section][cell];
    bool isCellActive = !isSectionLocked && 
                       isSectionActive && 
                       (widget.vsAI ? currentPlayer == 0 : true);

    return GestureDetector(
      onTap: isCellActive ? () => _makeMove(section, cell) : null,
      child: Container(
        color: isCellActive ? Color(0xFFF4EBD0) : Colors.grey[300],
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: 28,
              color: symbol == 'X' ? Colors.red : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _GameOverDialog extends StatelessWidget {
  final String message;
  final VoidCallback resetGame;

  const _GameOverDialog({required this.message, required this.resetGame});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFDEB887),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFF5C4033), width: 4),
          boxShadow: [
            BoxShadow(color: Colors.black54, blurRadius: 15),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game Over',
              style: TextStyle(
                fontSize: 28,
                color: Color(0xFF5C4033),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 15),
            Text(
              message,
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF8B4513),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Color(0xFF5C4033),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text(
                    'Play Again',
                    style: TextStyle(
                      color: Color(0xFF5C4033),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    resetGame();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RulesDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFDEB887),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFF5C4033), width: 2),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to Play',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C4033),
                ),
              ),
              SizedBox(height: 20),
              _RuleSection(
                title: '🎯 Objective',
                content: 'Win 3 mini-games in a row on the main board (like regular tic-tac-toe) '
                    'by winning individual 3x3 sections.',
              ),
              _RuleSection(
                title: '📐 Board Layout',
                content: '- 9 main sections, each containing a 3x3 grid\n'
                    '- Win a section by getting 3 in a row in its grid\n'
                    '- Win the game by getting 3 won sections in a row',
              ),
              _RuleSection(
                title: '🔄 Game Flow',
                content: '1. First move: Play anywhere\n'
                    '2. Next moves: Must play in the section matching the last move\'s cell position\n'
                    '   Example: Play in center cell → next move must be in center section\n'
                    '3. If target section is won/full: Choose any open section',
              ),
              _RuleSection(
                title: '🏆 Winning',
                content: '- Section win: 3 same symbols in a row (any direction)\n'
                    '- Game win: 3 won sections in a row (any direction)\n'
                    '- Draw: All sections filled with no 3-in-a-row winner',
              ),
              _RuleSection(
                title: '⚡ Special Rules',
                content: '- Won sections are locked (marked with big X/O)\n'
                    '- Drawn sections become inactive\n'
                    '- Refresh button restarts current game',
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Color(0xFF5C4033),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RuleSection extends StatelessWidget {
  final String title;
  final String content;

  const _RuleSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.arrow_right, color: Color(0xFF8B4513)),
              SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B4513),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.only(left: 24),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5C4033),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
