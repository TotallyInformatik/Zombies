import 'package:cod_zombies_2d/entities/collidables.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

class Player extends SpriteComponent with HasHitboxes, Collidable {

  Vector2 _moveDirection = Vector2.zero();

  double _speed = 200;

  Player(double srcX, double srcY, double size) :
        super(
          size: Vector2(
            size,
            size
          ),
          position: Vector2(
            srcX,
            srcY
          )
        );


  Future<void> onLoad() async {
    this.sprite = await Sprite.load('Top_Down_Survivor/rifle/idle/survivor-idle_rifle_0.png');
    this.anchor = Anchor.center;

    addHitbox(HitboxCircle());

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {

    if (other is CollidableObject) {
      if (intersectionPoints.length == 2) {
        final mid = ((intersectionPoints.elementAt(1) + intersectionPoints.elementAt(0)) / 2);

        final collisionNormal = absoluteCenter - mid;
        final seperationDistance = (size.x / 2) - collisionNormal.length;

        position += collisionNormal.normalized().scaled(seperationDistance);
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  void setPosition(double x, double y) {
    this.x = x;
    this.y = y;
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.position += _moveDirection.normalized() * _speed * dt;
  }

  void move(Set<LogicalKeyboardKey> keysPressed) {

    Vector2 playerMoveDirection = new Vector2(0, 0);

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      playerMoveDirection.y -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      playerMoveDirection.y += 1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      playerMoveDirection.x += 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      playerMoveDirection.x -= 1;
    }

    this._moveDirection = playerMoveDirection;

  }

  void stop(LogicalKeyboardKey key) {
    Vector2 currentPlayerMoveDirection = this._moveDirection;
    if (key == LogicalKeyboardKey.keyW) {
      currentPlayerMoveDirection.y += 1;
    }
    if (key == LogicalKeyboardKey.keyS) {
      currentPlayerMoveDirection.y -= 1;
    }
    if (key == LogicalKeyboardKey.keyA) {
      currentPlayerMoveDirection.x += 1;
    }
    if (key == LogicalKeyboardKey.keyD) {
      currentPlayerMoveDirection.x -= 1;
    }
    this._moveDirection = currentPlayerMoveDirection;
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }

  Vector2 getMoveDirection() { return _moveDirection; }

}