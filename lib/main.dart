
import 'package:cod_zombies_2d/entities/player.dart';
import 'package:cod_zombies_2d/entities/zombies.dart';
import 'package:cod_zombies_2d/maps/gamemap.dart';
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

  final List<Zombie> allZombies = [];
  static int dynamicMaxZombieCountCap = 10;
  static int hardMaxZombieCountCap = 60;
  static int currentZombieCount = 0;

  final int doorCost = 500;



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

  void passKeyEventToPlayer(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {

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

  }

  void handleOtherKeyEvents(Set<LogicalKeyboardKey> keysPressed) {

    if (keysPressed.contains(LogicalKeyboardKey.keyF)) {
      if (this.player.standingInDoorArea && this.player.points >= doorCost) {
        player.points -= doorCost;
        player.currentDoorArea.boundingRooms.e1.activateMonsterSpawnpoints();
        player.currentDoorArea.boundingRooms.e2.activateMonsterSpawnpoints();
        remove(player.currentDoorArea.physicalDoor);
        remove(player.currentDoorArea);

      }
    }

  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {

    passKeyEventToPlayer(event, keysPressed);
    handleOtherKeyEvents(keysPressed);

    return KeyEventResult.handled;

  }

  @override
  bool onTapDown(TapDownInfo event) {
    Vector2 tapPosition = event.eventPosition.game;

    for (final Zombie zombie in allZombies) {
      bool hitProcessed = zombie.onPlayerShoot(tapPosition);
      if (hitProcessed) {
        break;
      }
    }

    return true;
  }

  @override
  void onMouseMove(PointerHoverInfo info) {

    Vector2 pointerPosition = info.eventPosition.game;

    double pointerPositionX = pointerPosition.x;

    Vector2 playerPosition = this.player.position;
    double playerPositionX = playerPosition.x;

    double deltaX = pointerPositionX - playerPositionX;


    if (deltaX > 0) {
      player.setFaceDirection(PlayerFaceDirection.RIGHT);
    } else {
      player.setFaceDirection(PlayerFaceDirection.LEFT);
    }

  }

}


