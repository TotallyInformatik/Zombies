import 'package:cod_zombies_2d/entities/bullets/bullet.dart';
import 'package:flame/geometry.dart';
import 'package:flame/src/sprite.dart';
import 'package:vector_math/vector_math_64.dart';

class Arrow extends Bullet {

  @override
  int damage = 1;

  @override
  double speed = 100;

  Arrow(Vector2 normalizedMovementVector) : super(
    Vector2(
      12, 4
    ),
    normalizedMovementVector
  );

  @override
  Future<void> loadSprite() async {
    sprite = await Sprite.load("WeaponArrow.png");
  }

  @override
  Future<void> loadHitbox() async {
    addHitbox(HitboxRectangle());
  }

}