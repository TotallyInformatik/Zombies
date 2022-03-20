import 'package:cod_zombies_2d/entities/bullets/explosion.dart';
import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:cod_zombies_2d/maps/pathfinding/roomArea.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import '../zombies.dart';

class ZombieTNT extends Zombie {

  final double movementSpeed = 40;
  final Vector2 _hitboxRelation = Vector2(0.5, 1);


  ZombieTNT(srcX, srcY, RoomArea roomArea) : super(srcX, srcY, 1, roomArea);



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

    if (other is Player) {
      gameRef.add(Explosion(position));
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void processHit(int dHealth) {
    gameRef.add(Explosion(position));
    removeOneself();
  }

  @override
  Future<void> setupAnimations() async {

    animation = SpriteAnimation.spriteList([
      await Sprite.load("TNTZombieRun1.png"),
      await Sprite.load("TNTZombieRun2.png"),
      await Sprite.load("TNTZombieRun3.png"),
      await Sprite.load("TNTZombieRun4.png")
    ], stepTime: 0.1);

  }

}
