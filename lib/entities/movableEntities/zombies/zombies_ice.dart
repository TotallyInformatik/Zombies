import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:cod_zombies_2d/maps/pathfinding/roomArea.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import '../zombies.dart';

class ZombieIce extends Zombie {

  final double movementSpeed = 18;
  final Vector2 _hitboxRelation = Vector2(0.5, 1);


  ZombieIce(srcX, srcY, int hp, RoomArea roomArea) : super(srcX, srcY, hp, roomArea);



  @override
  Future<void>? onLoad() async {
    await setupAnimations();

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

  @override
  Future<void> setupAnimations() async {

    animation = SpriteAnimation.spriteList([
      await Sprite.load("IceZombieRun1.png"),
      await Sprite.load("IceZombieRun2.png"),
      await Sprite.load("IceZombieRun3.png"),
      await Sprite.load("IceZombieRun4.png")
    ], stepTime: 0.4);

  }

}
