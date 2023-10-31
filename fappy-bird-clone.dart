// Import the required libraries
import 'dart:math';
import 'package:flutter/material.dart';

// Define the main function
void main() => runApp(FlappyBird());

// Define the FlappyBird widget
class FlappyBird extends StatefulWidget {
  @override
  _FlappyBirdState createState() => _FlappyBirdState();
}

// Define the state of the FlappyBird widget
class _FlappyBirdState extends State<FlappyBird> {
  // Define the variables
  double birdY = 0;
  double initialHeight = 0;
  double height = 0;
  int score = 0;
  int bestScore = 0;
  int pipeNumber = 2;
  List<double> pipeX = [0, 0];
  List<double> pipeY = [0, 0];
  double pipeWidth = 60;
  double pipeHeight = 200;
  double gapSize = 150;
  double gravity = -5;
  double velocity = 0;
  double time = 0;
  bool gameStarted = false;
  bool gameOver = false;

  // Define the initState method
  @override
  void initState() {
    super.initState();
    resetGame();
  }

  // Define the resetGame method
  void resetGame() {
    birdY = 0;
    initialHeight = 0;
    height = 0;
    score = 0;
    pipeNumber = 2;
    pipeX = [0, 0];
    pipeY = [0, 0];
    velocity = 0;
    time = 0;
    gameStarted = false;
    gameOver = false;
    generatePipes();
  }

  // Define the generatePipes method
  void generatePipes() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double rand = Random().nextInt(200).toDouble() + 100;
    double gap = Random().nextInt(100).toDouble() + 150;
    pipeY[0] = rand - gap / 2;
    pipeY[1] = rand + gap / 2;
    pipeX[0] = width + pipeWidth;
    pipeX[1] = pipeX[0] + width / 2;
  }

  // Define the startGame method
  void startGame() {
    gameStarted = true;
    initialHeight = birdY;
  }

  // Define the jump method
  void jump() {
    if (gameOver) {
      resetGame();
    } else if (!gameStarted) {
      startGame();
    } else {
      velocity = 10;
    }
  }

  // Define the updateBird method
  void updateBird() {
    double timePassed = 0.025;
    velocity += gravity * timePassed;
    birdY -= velocity * timePassed;
    time += timePassed;
    if (time > 1.5) {
      time = 0;
      generatePipes();
    }
    if (birdY > height) {
      gameOver = true;
      if (score > bestScore) {
        bestScore = score;
      }
    }
    for (int i = 0; i < pipeNumber; i++) {
      if (pipeX[i] < -pipeWidth) {
        pipeX[i] += pipeNumber * pipeWidth;
        score++;
      }
      pipeX[i] -= 5;
      if (birdY < pipeY[i] + pipeHeight && birdY + 30 > pipeY[i] &&
          pipeX[i] + pipeWidth > 0 && birdY > 0) {
        gameOver = true;
        if (score > bestScore) {
          bestScore = score;
        }
      }
    }
  }

  // Define the build method
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: jump,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    alignment: Alignment(0, birdY / height + 0.5),
                    color: Colors.blue,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/bird.png'),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    alignment: Alignment(pipeX[0] / MediaQuery.of(context).size.width + 0.5,
                        pipeY[0] / height + 1),
                    child: Container(
                      height: height,
                      width: pipeWidth,
                      color: Colors.green,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    alignment: Alignment(pipeX[0] / MediaQuery.of(context).size.width + 0.5,
                        pipeY[1] / height - 1),
                    child: Container(
                      height: height,
                      width: pipeWidth,
                      color: Colors.green,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    alignment: Alignment(pipeX[1] / MediaQuery.of(context).size.width + 0.5,
                        pipeY[0] / height + 1),
                    child: Container(
                      height: height,
                      width: pipeWidth,
                      color: Colors.green,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    alignment: Alignment(pipeX[1] / MediaQuery.of(context).size.width + 0.5,
                        pipeY[1] / height - 1),
                    child: Container(
                      height: height,
                      width: pipeWidth,
                      color: Colors.green,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    alignment: Alignment(0, -0.3),
                    child: Text(
                      score.toString(),
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    alignment: Alignment(0, 0),
                    child: Text(
                      gameOver ? 'Game Over' : '',
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    alignment: Alignment(0, 0.3),
                    child: Text(
                      'Best Score: $bestScore',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: GestureDetector(
                  onTap: jump,
                  child: Center(
                    child: Text(
                      'Tap to Jump',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Define the tick method
  void tick(Duration duration) {
    if (gameStarted && !gameOver
