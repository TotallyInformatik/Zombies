import 'dart:math';

import 'package:cod_zombies_2d/entities/bullets/bullet.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Arrow extends Bullet with Collidable {

  @override
  int damage = 1;

  @override
  double speed = 100;

  Arrow(Vector2 srcPosition, Vector2 normalizedMovementVector) : super(
    srcPosition,
    Vector2(
      4, 12
    ),
    normalizedMovementVector
  );

  @override
  Future<void>? onLoad() {

    angle = atan(normalizedMovementVector.y / normalizedMovementVector.x);
    if (normalizedMovementVector.x > 0) {
      angle += pi/2;
    } else {
      angle -= pi/2;
    }

    return super.onLoad();
  }

  @override
  Future<void> loadSprite() async {
    sprite = await Sprite.load("WeaponArrow.png");
  }

  @override
  Future<void> loadHitbox() async {
    addHitbox(HitboxRectangle());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    handleCollision(other);
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(Collidable other) {
    handleCollision(other);
    super.onCollisionEnd(other);
  }

}