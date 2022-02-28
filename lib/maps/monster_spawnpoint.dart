import 'dart:async';
import 'dart:math';

import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:flame/components.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';

import '../entities/movableEntities/zombies/zombies_big.dart';
import '../entities/movableEntities/zombies/zombies_ice.dart';
import '../entities/movableEntities/zombies/zombies_small.dart';
import '../entities/movableEntities/zombies/zombies_tnt.dart';

class MonsterSpawnpoint extends PositionComponent with HasGameRef<ZombiesGame> {

  static const int spawnDelayInSeconds = 2;
  static const int spawnInterval = 12;
  static const int maxPlayerDistance = 150;


  final String name;

  /// this activated attribute refers to whether or not the room in which
  /// the monsterspawpoint is located is opened
  bool activated = false;

  /// this [active] attribute refers to the activity status of the monster spawnpoint
  /// resulting from the distance to the player
  bool active = true;

  late NeatPeriodicTaskScheduler spawnTimer;

  late NeatPeriodicTaskScheduler distanceCheckTimer;
  MonsterSpawnpoint(x, y, sizeX, sizeY, this.name) : super(position: Vector2(x, y), size: Vector2(sizeX, sizeY));

  @override
  Future<void>? onLoad() {
    _setSpawnTimer();
    return super.onLoad();
  }

  void _setSpawnTimer() {
    spawnTimer = NeatPeriodicTaskScheduler(
      interval: const Duration(seconds: spawnInterval),
      name: 'spawn-timer-${name}',
      timeout: const Duration(seconds: 1),
      task: () async {
        _spawnZombie();
      },
      minCycle: const Duration(seconds: 1),
    );

  }

  void checkPlayerDistance() {

    ///
    /// if player is not in the vicinity of the monster spawnpoint,
    /// then the spawnpoint will not spawn.
    ///

    if (activated) {
      double spawnpointDistanceFromPlayer = distance(gameRef.player);

      if (spawnpointDistanceFromPlayer > maxPlayerDistance) {
        setInactive();
      } else {
        setActive();
      }
    }

  }

  void setInactive() {
    if (active) {
      active = false;
      print("set inactive ${name}");
      spawnTimer.stop();
    }
  }

  void setActive() {
    if (!active) {
      active = true;
      print("set active ${name}");
      _setSpawnTimer();
      spawnTimer.start();
    }
  }

  void activateMonsterSpawnpoint() {

    if (!activated) {

      Future.delayed(const Duration(seconds: spawnDelayInSeconds)).then((value) {
        activated = true;
        spawnTimer.start();
      });

    }

  }


  void _spawnZombie() {

    if (gameRef.gameStatus != GameStatus.PLAYING) return;
    if (gameRef.currentZombieCount > gameRef.dynamicMaxZombieCountCap) return;

    print("spawning at ${name}");


    Random random = new Random();
    int randomNumber = random.nextInt(101);
    if(randomNumber < 50) {
      Zombie newZombie = Zombie(position.x + (size.x / 2), position.y, 5);
      gameRef.add(newZombie);
      gameRef.allZombies.add(newZombie);
      gameRef.currentZombieCount++;
    }
    else if(randomNumber >= 50 && randomNumber < 55) {
      ZombieTNT newTNTZombie = ZombieTNT(position.x + (size.x / 2), position.y, 5);
      gameRef.add(newTNTZombie);
      gameRef.allZombies.add(newTNTZombie);
      gameRef.currentZombieCount++;
    }
    else if(randomNumber >= 55 && randomNumber < 70) {
      ZombieIce newIceZombie = ZombieIce(position.x + (size.x / 2), position.y, 5);
      gameRef.add(newIceZombie);
      gameRef.allZombies.add(newIceZombie);
      gameRef.currentZombieCount++;
    }
    else if(randomNumber >= 70 && randomNumber < 85) {
      ZombieSmall newSmallZombie = ZombieSmall(position.x + (size.x / 2), position.y, 3);
      gameRef.add(newSmallZombie);
      gameRef.allZombies.add(newSmallZombie);
      gameRef.currentZombieCount++;
    }
    else if(randomNumber >= 85 && randomNumber < 101) {
      ZombieBig newBigZombie = ZombieBig(
          position.x + (size.x / 2), position.y, 10);
      gameRef.add(newBigZombie);
      gameRef.allZombies.add(newBigZombie);
      gameRef.currentZombieCount++;
    }

  }

}