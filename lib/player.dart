import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

class Player extends SpriteComponent with HasHitboxes, Collidable {

  Vector2 _moveDirection = Vector2.zero();

  double _speed = 300;

  Player() : super(size: Vector2.all(100));

  Future<void> onLoad() async {
    this.sprite = await Sprite.load('Top_Down_Survivor/rifle/idle/survivor-idle_rifle_0.png');
    this.anchor = Anchor.center;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    this.position = gameSize / 2;
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