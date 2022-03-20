import 'package:cod_zombies_2d/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class RoomArea extends PositionComponent with HasHitboxes, Collidable, HasGameRef<ZombiesGame> {

  final int roomNumber;
  late final Vector2 roomPoint;
  bool active = true;
  late final List<RoomArea> neighboringRooms = [];

  RoomArea(Vector2 position, Vector2 dimensions, this.roomNumber) : super(position: position, size: dimensions);

  @override
  bool operator ==(Object other) {
    if (other is! RoomArea) return false;
    return this.roomNumber == other.roomNumber;
  }

  @override
  Future<void>? onLoad() {

    addHitbox(HitboxRectangle());
    collidableType = CollidableType.passive;

    return super.onLoad();
  }



}