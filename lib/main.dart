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
  late final SpriteComponent crosshair;

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

    setupCrosshair();

    return super.onLoad();

  }

  void setupCrosshair() async {
    crosshair = new SpriteComponent();
    crosshair.sprite = await Sprite.load('crosshair.png');
    crosshair.size = new Vector2(10, 10);
    crosshair.anchor = Anchor.center;
    this.add(crosshair);
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

    this.crosshair.x = pointerPositionX;
    this.crosshair.y = pointerPosition.y;

    if (deltaX > 0) {
      this.player.setStandardSprite();
    } else {
      this.player.setInvertedSprite();
    }

  }

}


