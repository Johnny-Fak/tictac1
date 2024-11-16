import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tictac1/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool oTurn = false;
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];
  List<int> matchedIndexes = [];

  int oScore = 0;
  int attempts = 0;
  int xScore = 0;
  int filledBox = 0;
  String resultDeclaration = '';
  bool winnerFound = false;
  Timer? timer;
  static const maxSeconds = 30;
  int seconds = maxSeconds;

  static var customFontWhite = GoogleFonts.coiny(
      textStyle: const TextStyle(
    color: Colors.white,
    letterSpacing: 3,
    fontSize: 22,
  ));

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
    SystemSound.play(SystemSoundType.click);
  }

  void resetTimer() {
    seconds = maxSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Player 1',
                              style: customFontWhite,
                            ),
                            Text(
                              xScore.toString(),
                              style: customFontWhite,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Player 2',
                              style: customFontWhite,
                            ),
                            Text(
                              oScore.toString(),
                              style: customFontWhite,
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
              Expanded(
                flex: 3,
                child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _tapped(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 5,
                              color: MainColor.primaryColor,
                            ),
                            color: matchedIndexes.contains(index)
                                ? MainColor.accentColor
                                : MainColor.secondaryColor,
                          ),
                          child: Center(
                            child: Text(
                              displayXO[index],
                              style: GoogleFonts.coiny(
                                  textStyle: TextStyle(
                                      fontSize: 64,
                                      color: MainColor.accentColor)),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        resultDeclaration,
                        style: customFontWhite,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildTimer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      setState(() {
        if (oTurn && displayXO[index] == '') {
          displayXO[index] = 'O';
          filledBox++;
        } else if (!oTurn && displayXO[index] == '') {
          displayXO[index] = 'X';
          filledBox++;
        }

        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    //1st row
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player${displayXO[0]} Wins!';
        matchedIndexes.addAll([0, 1, 2]);
        stopTimer();
        _updateScore(displayXO[0]);
        winnerFound = false;
      });
    }
    //2nd row
    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      setState(() {
        resultDeclaration = 'Player${displayXO[3]} Wins!';
        matchedIndexes.addAll([3, 4, 5]);
        stopTimer();
        _updateScore(displayXO[3]);
        winnerFound = false;
      });
    }
    //3rd row
    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      setState(() {
        resultDeclaration = 'Player${displayXO[6]} Wins!';
        matchedIndexes.addAll([6, 7, 8]);
        stopTimer();
        _updateScore(displayXO[6]);
        winnerFound = false;
      });
    }
    //left side
    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player${displayXO[0]} Wins!';
        matchedIndexes.addAll([0, 3, 6]);
        stopTimer();
        _updateScore(displayXO[0]);
        winnerFound = false;
      });
    }
    //middle side
    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      setState(() {
        resultDeclaration = 'Player${displayXO[1]} Wins!';
        matchedIndexes.addAll([1, 4, 7]);
        stopTimer();
        _updateScore(displayXO[1]);
        winnerFound = false;
      });
    }
    //right side
    if (displayXO[2] == displayXO[8] &&
        displayXO[2] == displayXO[5] &&
        displayXO[2] != '') {
      setState(() {
        resultDeclaration = 'Player${displayXO[2]} Wins!';
        matchedIndexes.addAll([8, 5, 2]);
        stopTimer();
        _updateScore(displayXO[2]);
        winnerFound = false;
      });
    }
    //left diagonal
    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player${displayXO[0]} Wins!';
        matchedIndexes.addAll([0, 4, 8]);
        stopTimer();
        _updateScore(displayXO[0]);
        winnerFound = false;
      });
    }
    //right diagonal
    if (displayXO[2] == displayXO[4] &&
        displayXO[2] == displayXO[6] &&
        displayXO[2] != '') {
      setState(() {
        resultDeclaration = 'Player${displayXO[2]} Wins!';
        matchedIndexes.addAll([6, 4, 2]);
        stopTimer();
        _updateScore(displayXO[2]);
        winnerFound = false;
      });
    } else if (filledBox == 9 && !winnerFound) {
      resultDeclaration = 'Nobody Wins!';

      stopTimer();
    }
    // if (!winnerFound && filledBox == 9) {
    //   setState(() {
    //     stopTimer();
    //     resultDeclaration = 'Nobody wins!';
    //   });
    // }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      for (var i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      resultDeclaration = '';
    });
    filledBox = 0;
    matchedIndexes = [];
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning
        ? SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 8,
                  backgroundColor: MainColor.accentColor,
                ),
                Center(
                  child: Text(
                    '$seconds',
                    style: customFontWhite,
                  ),
                )
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: MainColor.accentColor,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
            onPressed: () {
              startTimer();
              _clearBoard();
              attempts++;
            },
            child: Text(
              attempts == 0 ? 'Start' : 'Play Again',
              style: customFontWhite,
            ));
  }
}
