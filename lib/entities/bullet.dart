import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Bullet extends SpriteComponent with HasGameRef<ZombiesGame>, HasHitboxes, Collidable {

  final Vector2 normalizedMovementVector;
  final double _speed = 200;
  final int _damage;

  Bullet(this.normalizedMovementVector, this._damage, Vector2 playerPosition) :
        super(
          position: playerPosition,
          size: Vector2.all(5)
        );

  @override
  Future<void>? onLoad() async {

    sprite = await Sprite.load("crosshair.png");
    addHitbox(HitboxCircle());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += normalizedMovementVector * _speed * dt;
    super.update(dt);
  }

  handleCollision(Collidable other) {

    if (other is! Player && other is! Bullet) {
      gameRef.remove(this);
    }

    if (other is Zombie) {
      other.processHit(_damage);
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