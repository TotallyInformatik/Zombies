import 'package:cod_zombies_2d/datastructures/pair.dart';
import 'package:cod_zombies_2d/entities/bullets/explosion.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:cod_zombies_2d/maps/door/door_area.dart';
import 'package:cod_zombies_2d/maps/easteregg/exit_area.dart';
import 'package:cod_zombies_2d/maps/easteregg/skull_area.dart';
import 'package:cod_zombies_2d/maps/monster_spawnpoint.dart';
import 'package:cod_zombies_2d/maps/pathfinding/roomArea.dart';
import 'package:cod_zombies_2d/maps/perks/double_tap.dart';
import 'package:cod_zombies_2d/maps/perks/juggernog.dart';
import 'package:cod_zombies_2d/maps/perks/mule_kick.dart';
import 'package:cod_zombies_2d/maps/perks/perk_area.dart';
import 'package:cod_zombies_2d/maps/perks/quick_revive.dart';
import 'package:cod_zombies_2d/maps/room.dart';
import 'package:cod_zombies_2d/maps/weapons/weapon.dart';
import 'package:cod_zombies_2d/maps/weapons/weapon_area.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';

class GameMap extends Component with HasGameRef<ZombiesGame> {

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

  final Map<int, int> monsterSpawnpointNumberToRoomAreaNumber = {
    1: 1,
    2: 1,
    3: 3,
    4: 7,
    5: 7,
    6: 15,
    7: 15,
    8: 13,
    9: 5,
    10: 5,
    11: 18,
    12: 18,
    13: 18
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

  final Map<int, int> doorAreaNumberToPathfindingRoomAreaNumber = {
    1: 2,
    2: 4,
    3: 19,
    4: 6,
    5: 9,
    6: 12,
    7: 14,
    8: 10,
    9: 17
  };

  Map<int, RoomArea> numberToPathfindingRoomArea = {};


  final String mapName;

  late final Player player;
  late final ExitArea exit_area;

  final String roomPrefix = "room_";
  final String roomPointPrefix = "room_points_";
  final String areaPrefix = "area_";
  final String physicalDoorPrefix = "physical_";
  final String monsterSpawnpointPrefix = "monster_spawnpoint_";

  final Map<String, MonsterSpawnpoint> monsterSpawnpoints = {};
  final Map<String, Room> rooms = {};
  final Map<String, Door> physicalDoors = {};

  final String quickReviveTag = "quick_revive";
  final String muleKickTag = "mule_kick";
  final String doubleTapTag = "double_tap";
  final String juggernogTag = "juggernog";

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

    final spawnPointsLayer = map.tileMap.getObjectGroupFromLayer("Spawnpoints");
    
    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.type) {
        case "player":
          player = Player(spawnPoint.x, spawnPoint.y, spawnPoint.width / Player.spriteHeight * 1.5);
          add(player);
          break;
        case "monster":

          String name = spawnPoint.name;
          int number = int.parse(name.split("_").last);

          MonsterSpawnpoint monsterSpawnpoint =
            MonsterSpawnpoint(spawnPoint.x, spawnPoint.y, spawnPoint.width, spawnPoint.height, spawnPoint.name, numberToPathfindingRoomArea[monsterSpawnpointNumberToRoomAreaNumber[number]]!);
          add(monsterSpawnpoint);
          monsterSpawnpoints[spawnPoint.name] = monsterSpawnpoint;
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

    final wallsLayer = map.tileMap.getObjectGroupFromLayer("Walls");

    for (final wall in wallsLayer.objects) {
      final collidableWall = Wall(
        Vector2(wall.x, wall.y),
        Vector2(wall.width, wall.height)
      );
      add(collidableWall);
    }

  }

  void _setupDoors() async {

    /// setting up actual physical doors with collision boxes
    final physicalDoorsLayer = map.tileMap.getObjectGroupFromLayer("PhysicalDoors");

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

    /// setting up spike sprites
    Map<int, List<SpriteComponent>> doorAreaNumberToSpriteComponent = {};

    Sprite spike = await Sprite.load("FloorSpikes.png");
    for (int i=1; i<10; i++) {

      final doorArea = map.tileMap.getObjectGroupFromLayer("Door${i}");
      List<SpriteComponent> currentDoorSprites = [];

      for (final doorAreaObject in doorArea.objects) {

        SpriteComponent currentSprite = SpriteComponent(
          sprite: spike,
          position: Vector2(
              doorAreaObject.x,
              doorAreaObject.y
          ),
          size: Vector2(
              doorAreaObject.width,
              doorAreaObject.height
          ),
        );

        gameRef.add(currentSprite);
        currentDoorSprites.add(currentSprite);

      }

      doorAreaNumberToSpriteComponent[i] = currentDoorSprites;

    }


    /// setting up the interactive areas for doors
    final doorAreasLayer = map.tileMap.getObjectGroupFromLayer("DoorAreas");

    for (final doorAreaObject in doorAreasLayer.objects) {

      int doorAreaNumber = int.parse(doorAreaObject.name.split("_")[1]);
      Pair<int, int> boundingRoomNumbers = doorAreaToBoundingRooms[doorAreaNumber]!;
      Room boundingRoom1 = rooms["${roomPrefix}${boundingRoomNumbers.e1}"]!;
      Room boundingRoom2 = rooms["${roomPrefix}${boundingRoomNumbers.e2}"]!;
      Door correspondingPhysicalDoor = physicalDoors["${physicalDoorPrefix}${doorAreaNumber}"]!;
      RoomArea? correspondingRoomArea = numberToPathfindingRoomArea[doorAreaNumberToPathfindingRoomAreaNumber[doorAreaNumber]];
      correspondingRoomArea?.active = false;

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
        Pair<Room, Room>(boundingRoom1, boundingRoom2),
        doorAreaNumberToSpriteComponent[doorAreaNumber]!,
        correspondingRoomArea!
      );
      add(newDoorArea);

    }

  }

  void _setupPerks() {

    final perkAreaLayer = map.tileMap.getObjectGroupFromLayer("PerkAreas");

    for (final perkArea in perkAreaLayer.objects) {

      PerkArea area = QuickRevive(Vector2.zero(), Vector2.zero());
      String perkType = perkArea.type;
      Vector2 perkAreaPosition = Vector2(
        perkArea.x,
        perkArea.y
      );
      Vector2 perkAreaSize = Vector2(
        perkArea.width,
        perkArea.height
      );

      if (perkType == quickReviveTag) {
        area = QuickRevive(perkAreaPosition, perkAreaSize);
      } else if (perkType == muleKickTag) {
        area = MuleKick(perkAreaPosition, perkAreaSize);
      } else if (perkType == juggernogTag) {
        area = Juggernog(perkAreaPosition, perkAreaSize);
      } else if (perkType == doubleTapTag) {
        area = DoubleTap(perkAreaPosition, perkAreaSize);
      }

      add(area);

    }

  }

  Future<void> _setupWeapons() async {

    final weaponAreaLayer = map.tileMap.getObjectGroupFromLayer("WeaponAreas");

    Weapon bowWeapon = await bow();
    Weapon spearWeapon = await spear();
    Weapon apprenticesStaffWeapon = await apprenticesStaff();

    Weapon meguminWeapon = await megumin();
    Weapon excaliburWeapon = await excalibur();


    for (final weaponAreaObject in weaponAreaLayer.objects) {

      Vector2 position = Vector2(
          weaponAreaObject.x,
          weaponAreaObject.y
      );
      Vector2 size = Vector2(
          weaponAreaObject.width,
          weaponAreaObject.height
      );

      switch(weaponAreaObject.type) {

        case "bow":
          add(WeaponArea(
            position,
            size,
            bowWeapon,
            750,
            "Press F to buy / refill Bow (750)"
          ));
          break;
        case "spear":
          add(WeaponArea(
            position,
            size,
            spearWeapon,
            1250,
            "Press F to buy / refill Spears (1250)"
          ));
          break;
        case "apprentices_staff":
          add(WeaponArea(
            position,
            size,
            apprenticesStaffWeapon,
            1250,
            "Press F to buy / refill Apprentice's staff (1250)"
          ));
          break;
        case "megumin":
          add(WeaponArea(
            position,
            size,
            meguminWeapon,
            2000,
            "Press F to buy / refill Megumin (2000)"
          ));
          break;
        case "excalibur":
          add(WeaponArea(
              position,
              size,
              excaliburWeapon,
              10000,
              "Press F to buy Excalibur (10000)"
          ));
          break;

      }

    }

  }

  void _setupEasterEgg() {

    final eastereggObject = map.tileMap.getObjectGroupFromLayer("EasterEgg");

    for (final eastereggObject in eastereggObject.objects) {

      Vector2 position = Vector2(
          eastereggObject.x,
          eastereggObject.y
      );
      Vector2 size = Vector2(
        eastereggObject.width,
        eastereggObject.height
      );

      switch (eastereggObject.type) {
        case "skull":
          add(SkullArea(position));
          break;
        case "exit":
          exit_area = ExitArea(position, size);
          add(exit_area);
          break;
      }

    }

  }

  addNeighborToRoomArea(int roomNumber, int neighborNumber) {
    numberToPathfindingRoomArea[roomNumber]!.neighboringRooms.add(numberToPathfindingRoomArea[neighborNumber]!);
    numberToPathfindingRoomArea[neighborNumber]!.neighboringRooms.add(numberToPathfindingRoomArea[roomNumber]!);
  }

  void _setupPathfinding() {

    final roomObjects = map.tileMap.getObjectGroupFromLayer("PathfindingRooms");

    for (final roomObject in roomObjects.objects) {

      String type = roomObject.type;
      int number = int.parse(type.split("_").last);

      RoomArea newRoomArea = RoomArea(
          Vector2(
              roomObject.x,
              roomObject.y
          ),
          Vector2(
              roomObject.width,
              roomObject.height
          ),
          number
      );

      numberToPathfindingRoomArea[number] = newRoomArea;
      add(newRoomArea);

    }

    final roomPointObjects = map.tileMap.getObjectGroupFromLayer("PathfindingRoomPoints");

    for (final roomPointObject in roomPointObjects.objects) {

      String type = roomPointObject.type;
      int number = int.parse(type.split("_").last);

      numberToPathfindingRoomArea[number]?.roomPoint = Vector2(
        roomPointObject.x,
        roomPointObject.y
      );

    }

    /// setting up the graph for the pathfinding algorithm:
    addNeighborToRoomArea(1, 2);
    addNeighborToRoomArea(1, 4);
    addNeighborToRoomArea(2, 3);
    addNeighborToRoomArea(3, 19);
    addNeighborToRoomArea(7, 19);
    addNeighborToRoomArea(4, 5);
    addNeighborToRoomArea(5, 6);
    addNeighborToRoomArea(6, 7);
    addNeighborToRoomArea(7, 10);
    addNeighborToRoomArea(10, 11);
    addNeighborToRoomArea(11, 16);
    addNeighborToRoomArea(16, 15);
    addNeighborToRoomArea(15, 14);
    addNeighborToRoomArea(13, 14);
    addNeighborToRoomArea(13, 12);
    addNeighborToRoomArea(5, 12);
    addNeighborToRoomArea(5, 9);
    addNeighborToRoomArea(8, 9);
    addNeighborToRoomArea(11, 17);
    addNeighborToRoomArea(18, 17);

  }

  void _setupMap() {

    _setupWalls();
    _setupPathfinding();
    _setupSpawnpoints();
    _setupMonsterSpawnpointPeriodicDistanceCheck();
    _setupRooms();

    _setupPerks();
    _setupWeapons();

    _setupEasterEgg();

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