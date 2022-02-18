import 'package:cod_zombies_2d/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  final zombiesGame = ZombiesGame();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            GameWidget(game: zombiesGame)
          ]
        )
      )
    )
  );
}


