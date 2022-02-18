import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Zombie extends SpriteComponent with HasHitboxes, Collidable, HasGameRef<ZombiesGame>, MoveableEntity {

  static final standardZombieSprite = Sprite.load("ZombieStandard.png");

  //final String spriteName;
  final double _movementSpeed = 15;
  final Vector2 _hitboxRelation = Vector2(0.5, 1);

  final int _movementFrameInterval = 1;

  double _accumulatedDt = 0;
  double _accumulatedFrames = 0;

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
    //sprite = await Sprite.load(spriteName);
    sprite = await standardZombieSprite;
    anchor = Anchor.center;
    addHitbox(HitboxRectangle(relation: _hitboxRelation));
    return super.onLoad();
  }

  @override
  void update(double dt) {

    _accumulatedFrames++;
    _accumulatedDt += dt;

    if (_accumulatedFrames > _movementFrameInterval) {
      followPlayer(_accumulatedDt);
      _accumulatedFrames = 0;
      _accumulatedDt = 0;
    }


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
  void processHit() {
    hp--;
    gameRef.player.points += Player.hitPointIncrease;
    gameRef.ui.updatePoints();
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

}
