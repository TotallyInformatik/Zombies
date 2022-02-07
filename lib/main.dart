import 'dart:math';

import 'package:cod_zombies_2d/player.dart';
import 'package:cod_zombies_2d/test.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/extensions.dart';

void main() async {
  final zombiesGame = ZombiesGame();
  runApp(
    GameWidget(game: zombiesGame)
  );
}

class ZombiesGame extends FlameGame with HasCollidables, KeyboardEvents, MouseMovementDetector, TapDetector {

  late final Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    this.player = new Player();

    this.add(this.player);

  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {

    print(event);

    switch (event.runtimeType) {
      case RawKeyDownEvent: {
        player.move(keysPressed);
        break;
      }
      case RawKeyUpEvent: {
        player.stop(event.logicalKey);
        break;
      }
    }

    return KeyEventResult.handled;

  }

  @override
  bool onTapDown(TapDownInfo event) {
    Vector2 tapPosition = event.eventPosition.viewport;

    this.add(new Test(tapPosition));

    return true;
  }

  @override
  void onMouseMove(PointerHoverInfo info) {

    Vector2 pointerPosition = info.eventPosition.viewport;

    double pointerPositionX = pointerPosition.x;
    double pointerPositionY = pointerPosition.y;

    Vector2 playerPosition = this.player.position;
    double playerPositionX = playerPosition.x;
    double playerPositionY = playerPosition.y;

    double deltaX = pointerPositionX - playerPositionX;
    double deltaY = pointerPositionY - playerPositionY;


    if (deltaX > 0) {
      this.player.angle = atan(deltaY / deltaX);
    } else {
      // Wieso 135?
      this.player.angle = 135 + atan(deltaY / deltaX);
    }

  }

}


