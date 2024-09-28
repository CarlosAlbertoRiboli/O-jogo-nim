import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(NimGame());
}

class NimGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedSticks = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Nim'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo ao Jogo Nim!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Selecione a quantidade de palitos para a partida:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            DropdownButton<int>(
              value: selectedSticks,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blue, fontSize: 18),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (int? newValue) {
                setState(() {
                  selectedSticks = newValue!;
                });
              },
              items: <int>[7, 8, 9, 10, 11, 12, 13]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameScreen(
                            totalSticks: selectedSticks,
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                'Iniciar Jogo',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final int totalSticks;

  GameScreen({required this.totalSticks});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int remainingSticks;
  bool isPlayerTurn = true;
  String message = 'Sua vez! Escolha entre 1 a 3 palitos.';

  @override
  void initState() {
    super.initState();
    remainingSticks = widget.totalSticks;
  }

  void playerMove(int sticks) {
    if (sticks < 1 || sticks > 3 || sticks > remainingSticks) {
      setState(() {
        message = 'Escolha um número válido de palitos!';
      });
      return;
    }

    setState(() {
      remainingSticks -= sticks;
      isPlayerTurn = false;
      message = 'Agora é a vez do computador...';
    });

    if (remainingSticks <= 0) {
      setState(() {
        message = 'Você perdeu! O computador ganhou.';
      });
    } else {
      Future.delayed(Duration(seconds: 1), () {
        computerMove();
      });
    }
  }

  void computerMove() {
    int sticksToRemove = min(remainingSticks, Random().nextInt(3) + 1);

    setState(() {
      remainingSticks -= sticksToRemove;
      isPlayerTurn = true;
      message = 'O computador tirou $sticksToRemove palitos. Sua vez!';
    });

    if (remainingSticks <= 0) {
      setState(() {
        message = 'Parabéns! Você venceu o jogo!';
      });
    }
  }

  void resetGame() {
    Navigator.pop(context); // Volta para a tela inicial
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Nim'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Palitos restantes: $remainingSticks',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isPlayerTurn ? Colors.blue[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),
              if (isPlayerTurn) ...[
                Text(
                  'Escolha quantos palitos deseja tirar:',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => playerMove(1),
                      child: Text('1'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => playerMove(2),
                      child: Text('2'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => playerMove(3),
                      child: Text('3'),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: resetGame,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  'Reiniciar Jogo',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
