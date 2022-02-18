import 'package:cod_zombies_2d/entities/bullet.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/maps/gamemap.dart';
import 'package:cod_zombies_2d/maps/monster_spawnpoint.dart';
import 'package:cod_zombies_2d/ui/overlay_ui.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/extensions.dart';

enum GameStatus {
  PLAYING,
  GAMEOVER
}

class ZombiesGame extends FlameGame with HasCollidables, KeyboardEvents, MouseMovementDetector, TapDetector {

  GameStatus gameStatus = GameStatus.PLAYING;

  late final Player player;
  late final OverlayUI ui;

  final List<Zombie> allZombies = [];
  static int hardMaxZombieCountCap = 20;

  int dynamicMaxZombieCountCap = 5;
  int currentZombieCount = 0;

  final int doorCost = 500;

  late final GameMap map;

  @override
  Future<void> onLoad() async {

    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    this.map = new GameMap("map2.tmx");
    await this.add(map);

    this.player = this.map.player;

    camera.viewport = FixedResolutionViewport(
        Vector2(465, 270)
    );

    camera.followComponent(
        player
    );

    ui = OverlayUI();
    add(ui);

    return super.onLoad();
  }

  void endGame() {

    /// removing all zombies
    for (final Zombie zombie in allZombies) {
      remove(zombie);
    }
    allZombies.clear();
    gameStatus = GameStatus.GAMEOVER;

    /// stopping monster spawning
    for (final MonsterSpawnpoint monsterSpawnpoint in map.monsterSpawnpoints.values) {
      monsterSpawnpoint.setInactive();
    }
    map.monsterSpawnpointActivityCheckTimer.stop();

  }

  void _passKeyEventToPlayer(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {

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

  void playerUse() {
    if (player.standingInDoorArea && player.points >= doorCost) {
      player.points -= doorCost;
      player.currentDoorArea.boundingRooms.e1.activateMonsterSpawnpoints();
      player.currentDoorArea.boundingRooms.e2.activateMonsterSpawnpoints();
      remove(player.currentDoorArea.physicalDoor);
      remove(player.currentDoorArea);
      ui.updatePoints();

    }
  }

  void _handleOtherKeyEvents(Set<LogicalKeyboardKey> keysPressed) {

    if (keysPressed.contains(LogicalKeyboardKey.keyF)) {
      playerUse();
    }

  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {

    _passKeyEventToPlayer(event, keysPressed);
    _handleOtherKeyEvents(keysPressed);

    return KeyEventResult.handled;

  }

  @override
  bool onTapDown(TapDownInfo event) {
    Vector2 tapPosition = event.eventPosition.game;

    /*
    for (final Zombie zombie in allZombies) {
      bool hitProcessed = zombie.onPlayerShoot(tapPosition);
      if (hitProcessed) {
        break;
      }
    }
     */

    Vector2 bulletMovementVector = Vector2(
      tapPosition.x - player.x,
      tapPosition.y - player.y
    );

    Bullet bullet = Bullet(bulletMovementVector.normalized(), player.position);
    add(bullet);

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