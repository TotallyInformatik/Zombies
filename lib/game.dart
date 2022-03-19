import 'package:cod_zombies_2d/entities/bullets/bullet.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/maps/gamemap.dart';
import 'package:cod_zombies_2d/maps/monster_spawnpoint.dart';
import 'package:cod_zombies_2d/rounds_manager.dart';
import 'package:cod_zombies_2d/ui/overlay_ui.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/extensions.dart';

enum GameStatus {
  PLAYING,
  GAMEOVER,
  LOADING
}

class ZombiesGame extends FlameGame with HasCollidables, KeyboardEvents, MouseMovementDetector, TapDetector {

  GameStatus gameStatus = GameStatus.LOADING;

  final RoundsManager roundsManager = RoundsManager();
  late final Player player;
  late final OverlayUI ui;

  final List<Zombie> allZombies = [];

  Vector2 viewportDimensions = Vector2(465, 270);

  late final GameMap map;

  @override
  Future<void> onLoad() async {

    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    map = GameMap("map2.tmx");
    await add(map);

    player = map.player;

    camera.viewport = FixedResolutionViewport(viewportDimensions);

    camera.followComponent(
        player
    );

    ui = OverlayUI();
    add(ui);

    add(roundsManager);

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

  void openExit() {
    map.exit_area.activate();
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    if (gameStatus != GameStatus.PLAYING) return KeyEventResult.ignored;

    switch (event.runtimeType) {
      case RawKeyDownEvent:
        {
          if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
              keysPressed.contains(LogicalKeyboardKey.keyS) ||
              keysPressed.contains(LogicalKeyboardKey.keyA) ||
              keysPressed.contains(LogicalKeyboardKey.keyD)) {
            player.move(keysPressed);
          }

          if (keysPressed.contains(LogicalKeyboardKey.digit1) ||
              keysPressed.contains(LogicalKeyboardKey.digit2) ||
              keysPressed.contains(LogicalKeyboardKey.digit3)) {
            player.switchWeapons(keysPressed);
          }

          break;
        }
      case RawKeyUpEvent:
        {
          player.stop(event.logicalKey, keysPressed);
          break;
        }
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyF)) {
      player.use();
    }

    return KeyEventResult.handled;
  }

  @override
  bool onTapDown(TapDownInfo info) {

    if (gameStatus != GameStatus.PLAYING) return false;

    Vector2 tapPosition = info.eventPosition.game;
    player.shoot(tapPosition);

    return true;
  }

  @override
  void onMouseMove(PointerHoverInfo info) {

    if (gameStatus != GameStatus.PLAYING) return;

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