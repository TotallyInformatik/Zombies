import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'arrow.dart';


enum BulletTypes {
  ARROW
}

Bullet returnBulletFromBulletType(BulletTypes bulletType, Vector2 normalizedMovementVector) {

  switch(bulletType) {

    case BulletTypes.ARROW:
      return Arrow(normalizedMovementVector);
  }

}


abstract class Bullet extends SpriteComponent with HasGameRef<ZombiesGame>, HasHitboxes, Collidable {

  Vector2 normalizedMovementVector;
  abstract final double speed;
  abstract int damage;

  Bullet(Vector2 size, this.normalizedMovementVector) :
        super(
          size: size
        );

  /// should load the correct sprite for the bullet
  Future<void> loadSprite();

  /// should load the correct hitbox for the bullet
  Future<void> loadHitbox();

  @override
  Future<void>? onLoad() async {
    await loadSprite();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += normalizedMovementVector * speed * dt;
    super.update(dt);
  }

  handleCollision(Collidable other) {

    if (other is! Player && other is! Bullet) {
      gameRef.remove(this);
    }

    if (other is Zombie) {
      other.processHit(damage * gameRef.player.playerDamageFactor);
    }

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