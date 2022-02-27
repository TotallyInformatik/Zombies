import 'dart:math';

import 'package:cod_zombies_2d/entities/bullets/bullet.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Spear extends Bullet with Collidable {

  @override
  double speed = 200;

  @override
  int damage = 2;

  Spear(Vector2 srcPosition, Vector2 normalizedMovementVector) : super(
    srcPosition + normalizedMovementVector * 25,
    Vector2(
        6, 30
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
    sprite = await Sprite.load("WeaponSpear.png");
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