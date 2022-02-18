import 'package:cod_zombies_2d/datastructures/pair.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:cod_zombies_2d/maps/door/door_area.dart';
import 'package:cod_zombies_2d/maps/monster_spawnpoint.dart';
import 'package:cod_zombies_2d/maps/room.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';

class GameMap extends Component {

  // data section:
  // roomToMonsterSpawnpoint gibt an, in welchen Räumen (key) welche monsterSpawnpoints (value) sind
  // map2.tmx enthält weitere Informationen zu den Spawnpoints und den Räumen
  final Map<int, List<int>> roomToMonsterSpawnpoint = {
    1: [1, 2],
    2: [3],
    3: [4, 5],
    4: [9, 10],
    5: [],
    6: [8],
    7: [6, 7],
    8: [11, 12, 13],
  };

  // areaToBoundingRooms gibt an, welche Räume (value) an welche doorAreas (key) angrenzen
  final Map<int, Pair<int, int>> doorAreaToBoundingRooms = {
    1: Pair(1, 2),
    2: Pair(1, 4),
    3: Pair(2, 3),
    4: Pair(3, 4),
    5: Pair(4, 5),
    6: Pair(4, 6),
    7: Pair(6, 7),
    8: Pair(3, 7),
    9: Pair(7, 8)
  };


  final String mapName;

  late final Player player;

  final String roomPrefix = "room_";
  final String areaPrefix = "area_";
  final String physicalDoorPrefix = "physical_";
  final String monsterSpawnpointPrefix = "monster_spawnpoint_";

  final Map<String, MonsterSpawnpoint> monsterSpawnpoints = {};
  final Map<String, Room> rooms = {};
  final Map<String, Door> physicalDoors = {};

  late final TiledComponent map;

  late final int mapWidth;
  late final int mapHeight;
  late final int tileWidth;
  late final int tileHeight;
  late final int pixelWidth;
  late final int pixelHeight;

  late NeatPeriodicTaskScheduler monsterSpawnpointActivityCheckTimer;

  GameMap(this.mapName) : super();

  @override
  Future<void>? onLoad() async {

    await this._loadMap();
    this._setupMap();

    return super.onLoad();

  }


  void _setupRooms() {

    for (final MapEntry<int, List<int>> roomToMonsterSpawnpointEntry in roomToMonsterSpawnpoint.entries) {

      List<MonsterSpawnpoint> monsterSpawnpointsInThisRoom = [];
      for (int monsterSpawnpointIndex in roomToMonsterSpawnpointEntry.value) {
        monsterSpawnpointsInThisRoom.add(monsterSpawnpoints["${monsterSpawnpointPrefix}${monsterSpawnpointIndex}"]!);
      }

      rooms["${roomPrefix}${roomToMonsterSpawnpointEntry.key}"] = Room(monsterSpawnpointsInThisRoom);
    }

    rooms["${roomPrefix}1"]?.activateMonsterSpawnpoints();

  }

  void _setupSpawnpoints() {

    final spawnPointsLayer = this.map.tileMap.getObjectGroupFromLayer("Spawnpoints");
    
    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.type) {
        case "player":
          this.player = new Player(spawnPoint.x, spawnPoint.y, spawnPoint.width / Player.spriteHeight * 1.5);
          this.add(this.player);
          break;
        case "monster":
          MonsterSpawnpoint monsterSpawnpoint = new MonsterSpawnpoint(spawnPoint.x, spawnPoint.y, spawnPoint.width, spawnPoint.height, spawnPoint.name);
          this.add(monsterSpawnpoint);
          this.monsterSpawnpoints[spawnPoint.name] = monsterSpawnpoint;
          break;
      }
    }

  }

  void _setupMonsterSpawnpointPeriodicDistanceCheck() {

    monsterSpawnpointActivityCheckTimer = NeatPeriodicTaskScheduler(
      interval: const Duration(seconds: 2),
      name: 'periodicMonsterSpawnpointCheck',
      timeout: const Duration(seconds: 1),
      task: () async {

        for (MonsterSpawnpoint spawnpoint in this.monsterSpawnpoints.values) {
          spawnpoint.checkPlayerDistance();
        }

      },
      minCycle: const Duration(seconds: 1),
    );

    monsterSpawnpointActivityCheckTimer.start();

  }

  void _setupWalls() {

    final wallsLayer = this.map.tileMap.getObjectGroupFromLayer("Walls");

    for (final wall in wallsLayer.objects) {
      final collidableWall = Wall(
        Vector2(wall.x, wall.y),
        Vector2(wall.width, wall.height)
      );
      add(collidableWall);
    }

  }

  void _setupDoors() {

    final physicalDoorsLayer = this.map.tileMap.getObjectGroupFromLayer("PhysicalDoors");

    for (final physicalDoorObject in physicalDoorsLayer.objects) {

      Door newDoor = Door(
        Vector2(
          physicalDoorObject.x,
          physicalDoorObject.y
        ),
        Vector2(
          physicalDoorObject.width,
          physicalDoorObject.height
        )
      );
      add(newDoor);

      physicalDoors[physicalDoorObject.name] = newDoor;

    }

    final doorAreasLayer = this.map.tileMap.getObjectGroupFromLayer("DoorAreas");

    for (final doorAreaObject in doorAreasLayer.objects) {

      int doorAreaNumber = int.parse(doorAreaObject.name.split("_")[1]);
      Pair<int, int> boundingRoomNumbers = doorAreaToBoundingRooms[doorAreaNumber]!;
      Room boundingRoom1 = rooms["${roomPrefix}${boundingRoomNumbers.e1}"]!;
      Room boundingRoom2 = rooms["${roomPrefix}${boundingRoomNumbers.e2}"]!;
      Door correspondingPhysicalDoor = physicalDoors["${physicalDoorPrefix}${doorAreaNumber}"]!;

      DoorArea newDoorArea = DoorArea(
        Vector2(
            doorAreaObject.x,
            doorAreaObject.y
        ),
        Vector2(
            doorAreaObject.width,
            doorAreaObject.height
        ),
        correspondingPhysicalDoor,
        Pair<Room, Room>(boundingRoom1, boundingRoom2)
      );
      add(newDoorArea);

    }

  }
  
  void _setupMap() {

    _setupWalls();
    _setupSpawnpoints();
    _setupMonsterSpawnpointPeriodicDistanceCheck();

    _setupRooms();

    _setupDoors();

  }

  Future<void> _loadMap() async {

    this.map = await TiledComponent.load(this.mapName, Vector2.all(16));
    await add(this.map);

    final actualTileMap = map.tileMap.map;

    this.mapWidth = actualTileMap.width;
    this.mapHeight = actualTileMap.height;
    this.tileWidth = actualTileMap.tileWidth;
    this.tileHeight = actualTileMap.tileHeight;

    this.pixelWidth = this.mapWidth * this.tileWidth;
    this.pixelHeight = this.mapHeight * this.tileHeight;

  }

}