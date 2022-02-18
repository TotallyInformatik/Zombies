import 'package:cod_zombies_2d/datastructures/pair.dart';
import 'package:cod_zombies_2d/entities/collidables.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:cod_zombies_2d/maps/room.dart';
import 'package:flame/components.dart';


class DoorArea extends CollidableObject with Collidable {

  late final Door physicalDoor;
  late final Pair<Room, Room> boundingRooms;

  DoorArea(Vector2 position, Vector2 size, this.physicalDoor, this.boundingRooms) : super(position, size);

  @override
  Future<void>? onLoad() {
    return super.onLoad();
  }

}
