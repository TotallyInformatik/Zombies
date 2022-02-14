import 'package:cod_zombies_2d/entities/player.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/main.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Zombie extends SpriteComponent with HasHitboxes, Collidable, HasGameRef<ZombiesGame> {

  final String spriteName;
  final double _movementSpeed = 20;
  final Vector2 _hitboxRelation = Vector2(0.5, 1);

  int hp;

  Zombie(srcX, srcY, this.spriteName, this.hp) :
    super(
      position: Vector2(
        srcX,
        srcY
      ),
      size: Vector2(20, 20)
    );

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load(spriteName);
    anchor = Anchor.center;
    addHitbox(HitboxRectangle(relation: _hitboxRelation));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    followPlayer(dt);

    super.update(dt);
  }

  void handleImmovableCollision(Set<Vector2> intersectionPoints) {
    if (intersectionPoints.length == 2) {
      final mid = ((intersectionPoints.elementAt(1) + intersectionPoints.elementAt(0)) / 2);

      final collisionNormal = absoluteCenter - mid;
      final seperationDistance = (size.x / 2) - collisionNormal.length;


      position += collisionNormal.normalized().scaled(seperationDistance);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {

    if (other is Wall) {
      handleImmovableCollision(intersectionPoints);
    }

    super.onCollision(intersectionPoints, other);
  }

  bool onPlayerShoot(Vector2 cursorPosition) {
    HitboxShape currentHitbox = this.hitboxes[0];

    double xBoundOffsetFromCenter = currentHitbox.size.x * _hitboxRelation.x * 0.5;
    double zombieLeftBound = currentHitbox.position.x - xBoundOffsetFromCenter;
    double zombieRightBound = currentHitbox.position.x + xBoundOffsetFromCenter;

    double yBoundOffsetFromCenter = currentHitbox.size.y * _hitboxRelation.y * 0.5;
    double zombieUpperBound = currentHitbox.position.y - yBoundOffsetFromCenter;
    double zombieLowerBound = currentHitbox.position.y + yBoundOffsetFromCenter;


    if (zombieLeftBound < cursorPosition.x &&
        cursorPosition.x < zombieRightBound &&
        cursorPosition.y < zombieLowerBound &&
        zombieUpperBound < cursorPosition.y) {
      processHit();
      return true;
    }

    return false;

  }

  void processHit() {
    gameRef.player.points += Player.hitPointIncrease;
    hp--;
    if (hp <= 0) {
      removeOneself();
    }
  }

  void removeOneself() {
    gameRef.remove(this);
    gameRef.allZombies.remove(this);
    ZombiesGame.currentZombieCount--;
  }

  void followPlayer(double dt) {

    Player player = gameRef.player;
    double playerToZombieDeltaX = player.x - x;
    double playerToZombieDeltaY = player.y - y;

    Vector2 movementVector = Vector2(
      playerToZombieDeltaX,
      playerToZombieDeltaY
    );

    position += movementVector.normalized() * _movementSpeed * dt;

  }

}
