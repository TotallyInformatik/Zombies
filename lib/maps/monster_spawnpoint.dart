import 'dart:async';

import 'package:cod_zombies_2d/entities/zombies.dart';
import 'package:cod_zombies_2d/main.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';

class MonsterSpawnpoint extends PositionComponent with HasGameRef<ZombiesGame> {

  final String name;
  bool activated = false;
  late var spawnTimer;
  MonsterSpawnpoint(x, y, sizeX, sizeY, this.name) : super(position: Vector2(x, y), size: Vector2(sizeX, sizeY));

  @override
  Future<void>? onLoad() {
    return super.onLoad();
  }

  void setActive() {
    // TODO: make duration fixed as tiled map property!!!

    if (!activated) {

      spawnTimer = NeatPeriodicTaskScheduler(
        interval: Duration(seconds: 20),
        name: 'spawn-timer-${this.name}',
        timeout: Duration(seconds: 1),
        task: () async {
          print("spawning at ${this.name}");
          _spawnZombie();
        },
        minCycle: Duration(seconds: 1),
      );

      spawnTimer.start();

      activated = true;

    }

  }

  void _spawnZombie() {
    if (ZombiesGame.currentZombieCount <= ZombiesGame.dynamicMaxZombieCountCap) {
      Zombie newZombie = Zombie(position.x + (size.x / 2), position.y, "ZombieStandard.png", 3);
      gameRef.add(newZombie);
      gameRef.allZombies.add(newZombie);
      ZombiesGame.currentZombieCount++;
    }
  }

}