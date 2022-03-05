import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import '../zombies.dart';

class ZombieSmall extends Zombie {

  final double _movementSpeed = 30;
  final Vector2 _hitboxRelation = Vector2(0.5, 1);


  ZombieSmall(srcX, srcY, int hp) : super(srcX, srcY, hp);



  @override
  Future<void>? onLoad() async {
    await setupAnimations();

    size = Vector2.all(15);

    anchor = Anchor.center;
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
      await Sprite.load("SmallZombieRun1.png"),
      await Sprite.load("SmallZombieRun2.png"),
      await Sprite.load("SmallZombieRun3.png"),
      await Sprite.load("SmallZombieRun4.png")
    ], stepTime: 0.15);

  }

}