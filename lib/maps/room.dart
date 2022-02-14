import 'package:cod_zombies_2d/maps/monster_spawnpoint.dart';

class Room {

  final List<MonsterSpawnpoint> monsterSpawnpoints;

  Room(this.monsterSpawnpoints);

  void activateMonsterSpawnpoints() {
    this.monsterSpawnpoints.forEach((MonsterSpawnpoint spawnpoint) {
      spawnpoint.setActive();
    });
  }

}