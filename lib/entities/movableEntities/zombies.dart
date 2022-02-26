import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Zombie extends SpriteAnimationComponent with HasHitboxes, Collidable, HasGameRef<ZombiesGame>, MoveableEntity {

  final double _movementSpeed = 30;
  final Vector2 _hitboxRelation = Vector2(0.5, 1);

  int hp;

  Zombie(srcX, srcY, this.hp) :
    super(
      position: Vector2(
        srcX,
        srcY
      ),
      size: Vector2(20, 20),
    );

  @override
  Future<void>? onLoad() async {
    await setupAnimations();

    anchor = Anchor.center;
    addHitbox(HitboxRectangle(relation: _hitboxRelation));
    return super.onLoad();
  }

  @override
  void update(double dt) {

    followPlayer(dt);

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {

    if (other is Wall || other is Door) {
      handleImmovableCollision(intersectionPoints);
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void processHit(int dHealth) {
    hp -= dHealth;
    gameRef.player.changePoints(Player.hitPointIncrease);
    if (hp <= 0) {
      removeOneself();
    }
  }

  void removeOneself() {
    gameRef.remove(this);
    gameRef.allZombies.remove(this);
    gameRef.currentZombieCount--;
  }

  void followPlayer(double dt) {

    Player player = gameRef.player;

    Vector2 movementVector = Vector2(
      player.x - x,
      player.y - y
    );

    position += movementVector.normalized() * _movementSpeed * dt;

  }

  @override
  Future<void> setupAnimations() async {

    animation = SpriteAnimation.spriteList([
      await Sprite.load("ZombieRun1.png"),
      await Sprite.load("ZombieRun2.png"),
      await Sprite.load("ZombieRun3.png"),
      await Sprite.load("ZombieRun4.png")
    ], stepTime: 0.2);

  }

}
