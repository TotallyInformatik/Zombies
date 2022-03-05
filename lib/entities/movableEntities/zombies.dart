import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_big.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_ice.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_small.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_tnt.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

enum ZombieTypes {
  NORMAL,
  BIG,
  SMOLL,
  ICE,
  TNT
}

getZombieFromZombieType(double srcX, double srcY, ZombieTypes zombieType, int damageAdd) {

  switch (zombieType) {

    case ZombieTypes.NORMAL:
      return Zombie(srcX, srcY, 3 + damageAdd);
    case ZombieTypes.BIG:
      return ZombieBig(srcX, srcY, 5 + damageAdd);
    case ZombieTypes.SMOLL:
      return ZombieSmall(srcX, srcY, 2 + damageAdd);
    case ZombieTypes.ICE:
      return ZombieIce(srcX, srcY, 3 + damageAdd);
    case ZombieTypes.TNT:
      return ZombieTNT(srcX, srcY);
  }

}

class Zombie extends SpriteAnimationComponent with HasHitboxes, Collidable, HasGameRef<ZombiesGame>, MoveableEntity {

  final double _movementSpeed = 50;

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
    addHitbox(HitboxCircle(normalizedRadius: 0.7));
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
    Player player = gameRef.player;
    hp -= dHealth * player.playerDamageFactor;
    player.changePoints(Player.hitPointIncrease);
    position += (player.position - position).normalized() * -5;
    if (hp <= 0) {
      removeOneself();
    }
  }

  void removeOneself() {
    gameRef.remove(this);
    gameRef.allZombies.remove(this);
    gameRef.roundsManager.killZombie();
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
