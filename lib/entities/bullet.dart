import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Bullet extends SpriteComponent with HasGameRef<ZombiesGame>, HasHitboxes, Collidable {

  late Vector2 normalizedMovementVector;
  final double _speed = 200;
  int _damage;

  Bullet(this._damage, Sprite sprite, Vector2 size) :
        super(
          sprite: sprite,
          size: size
        );

  @override
  Future<void>? onLoad() async {
    addHitbox(HitboxCircle());
    return super.onLoad();
  }

  /// should always be called before adding this component
  void onAdd(Vector2 pNormalizedMovementVector) {
    position = gameRef.player.position;
    normalizedMovementVector = pNormalizedMovementVector;
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
      other.processHit(_damage * gameRef.player.playerDamageFactor);
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