import 'package:cod_zombies_2d/datastructures/pair.dart';
import 'package:cod_zombies_2d/entities/collidables.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:cod_zombies_2d/maps/interactive_area.dart';
import 'package:cod_zombies_2d/maps/room.dart';
import 'package:flame/components.dart';


class DoorArea extends CollidableObject with Collidable, HasGameRef<ZombiesGame> implements InteractiveArea {


  @override
  String tooltip = "press F to open door";
  late final Door physicalDoor;
  late final Pair<Room, Room> boundingRooms;

  final int doorCost = 500;

  DoorArea(Vector2 position, Vector2 size, this.physicalDoor, this.boundingRooms) : super(position, size);


  @override
  void onInteract() {

    Player player = gameRef.player;

    if (player.points >= doorCost) {

      player.points -= doorCost;
      boundingRooms.e1.activateMonsterSpawnpoints();
      boundingRooms.e2.activateMonsterSpawnpoints();
      gameRef.remove(physicalDoor);
      gameRef.remove(this);
      gameRef.ui.updatePoints();

    }

  }



}
