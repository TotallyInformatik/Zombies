import 'package:cod_zombies_2d/entities/bullets/bullet.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class ApprenticesOrb extends Bullet with Collidable {
  @override
  int damage = 1;

  @override
  double speed = 200;

  ApprenticesOrb(Vector2 srcPosition, Vector2 normalizedMovementVector) : super(
      srcPosition,
      Vector2.all(5),
      normalizedMovementVector
  );

  @override
  Future<void> loadHitbox() async {
    addHitbox(HitboxCircle());
  }

  @override
  Future<void> loadSprite() async {
    sprite = await Sprite.load("WeaponApprenticesBullet.png");
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