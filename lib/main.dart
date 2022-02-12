import 'dart:math';

import 'package:cod_zombies_2d/entities/player.dart';
import 'package:cod_zombies_2d/maps/gamemap.dart';
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

  late final GameMap map;

  @override
  Future<void> onLoad() async {

    this.map = new GameMap("map2.tmx");
    await this.add(map);

    this.player = this.map.player;

    camera.viewport = FixedResolutionViewport(
        Vector2(465, 270)
    );

    camera.followComponent(
        player,
        worldBounds: Rect.fromCenter(
          center: Offset(this.map.pixelWidth / 2, this.map.pixelHeight / 2),
          width: this.map.pixelWidth.toDouble(),
          height: this.map.pixelHeight.toDouble()
        )
    );

    return super.onLoad();

  }

  @override
  void render(Canvas canvas) {

    //Paint paint = new Paint();
    //paint.color = Colors.redAccent;
    //canvas.drawRect(Rect.largest, paint);
    super.render(canvas);

  }

  @override
  void resize(Vector2 newCanvasSize) {

  }


  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {

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
    Vector2 tapPosition = event.eventPosition.game;

    this.add(new Test(tapPosition));

    return true;
  }

  @override
  void onMouseMove(PointerHoverInfo info) {

    Vector2 pointerPosition = info.eventPosition.game;

    double pointerPositionX = pointerPosition.x;

    Vector2 playerPosition = this.player.position;
    double playerPositionX = playerPosition.x;

    double deltaX = pointerPositionX - playerPositionX;

    setCursorPosition(pointerPosition);

    if (deltaX > 0) {
      this.player.setStandardSprite();
    } else {
      this.player.setInvertedSprite();
    }

  }

  void setCursorPosition(Vector2 pointerPosition) {

    this.player.crosshair.x = pointerPosition.x;
    this.player.crosshair.y = pointerPosition.y;

  }

}


