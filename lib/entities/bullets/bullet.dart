import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:cod_zombies_2d/maps/door/door_area.dart';
import 'package:flame/components.dart';

import 'arrow.dart';


enum BulletTypes {
  ARROW
}

Bullet returnBulletFromBulletType(BulletTypes bulletType, Vector2 playerPosition, Vector2 normalizedMovementVector) {

  switch(bulletType) {

    case BulletTypes.ARROW:
      return Arrow(playerPosition, normalizedMovementVector);
  }

}


abstract class Bullet extends SpriteComponent with HasGameRef<ZombiesGame>, HasHitboxes, Collidable {

  Vector2 normalizedMovementVector;
  abstract final double speed;
  abstract int damage;

  Bullet(Vector2 srcPosition, Vector2 size, this.normalizedMovementVector) :
        super(
          position: srcPosition,
          size: size
        );

  /// should load the correct sprite for the bullet
  Future<void> loadSprite();

  /// should load the correct hitbox for the bullet
  Future<void> loadHitbox();

  @override
  Future<void>? onLoad() async {
    await loadSprite();
    await loadHitbox();
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

}