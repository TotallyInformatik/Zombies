import 'dart:html';

import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/hud/game_over_menu.dart';
import 'package:cod_zombies_2d/hud/main_menu.dart';
import 'package:cod_zombies_2d/hud/pause_menu.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    const MaterialApp(
      home: GamePage()
    )
  );
}

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final zombiesGame = ZombiesGame();

    return Scaffold(
        body: Stack(
            fit: StackFit.expand,
            children: [
              GameWidget(
                game: zombiesGame,
                loadingBuilder: (context) => const Center(
                    child: SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(color: Colors.white),
                    )
                ),
                overlayBuilderMap: {
                  MainMenu.id: (_, ZombiesGame gameRef) => MainMenu(gameRef),
                  PauseMenu.id: (_, ZombiesGame gameRef) => PauseMenu(gameRef),
                  GameOverMenu.id: (_, ZombiesGame gameRef) => GameOverMenu(gameRef)
                },
                initialActiveOverlays: const [MainMenu.id],
              )
            ]
        )
    );
  }


}


