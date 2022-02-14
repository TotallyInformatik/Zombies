import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/entities/zombies.dart';
import 'package:cod_zombies_2d/main.dart';
import 'package:cod_zombies_2d/maps/door.dart';
import 'package:cod_zombies_2d/maps/door_area.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

class Player extends SpriteComponent with HasGameRef<ZombiesGame>, HasHitboxes, Collidable {

  static final int spriteHeight = 28;
  static final int spriteWidth = 16;

  Vector2 _moveDirection = Vector2.zero();
  late final Sprite _standardSprite;
  late final Sprite _invertedSprite;

  double _speed = 100;
  int hp = 3;
  bool _currentlyInvincible = false;

  bool standingInDoorArea = false;
  late DoorArea currentDoorArea;

  int points = 500;
  static final hitPointIncrease = 40;

  Player(double srcX, double srcY, double sizeRelation) :
        super(
          size: Vector2(
            spriteWidth * sizeRelation,
            spriteHeight * sizeRelation
          ),
          position: Vector2(
            srcX,
            srcY
          )
        );


  Future<void> onLoad() async {
    this._standardSprite = await Sprite.load('Knight.png');
    this._invertedSprite = await Sprite.load('KnightInverted.png');

    this.sprite = this._standardSprite;
    this.anchor = Anchor.center;

    addHitbox(HitboxCircle(position: Vector2(100, 100)));

    //this.setupCrosshair();

    return super.onLoad();
  }


  void handleImmovableCollision(Set<Vector2> intersectionPoints) {
    if (intersectionPoints.length == 2) {
      final mid = ((intersectionPoints.elementAt(1) + intersectionPoints.elementAt(0)) / 2);

      final collisionNormal = absoluteCenter - mid;
      final seperationDistance = (size.x / 2) - collisionNormal.length;

      setPlayerPosition(collisionNormal.normalized().scaled(seperationDistance));
    }
  }

  /*
  void setupCrosshair() async {
    crosshair = new SpriteComponent();
    crosshair.sprite = await Sprite.load('crosshair.png');
    crosshair.size = new Vector2(10, 10);
    crosshair.anchor = Anchor.center;
    this.gameRef.add(this.crosshair);
  }
   */

  Future<void> invincibilityFrames() async {
    Future.delayed(Duration(seconds: 1), () {
      _currentlyInvincible = false;
    });
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {

    if (other is Door || other is Wall) {
      handleImmovableCollision(intersectionPoints);
    } else if (other is DoorArea) {
      standingInDoorArea = true;
      currentDoorArea = other;
    } else if (other is Zombie) {
      if (!_currentlyInvincible) {
        hp--;
        _currentlyInvincible = true;
        invincibilityFrames();
        print("player hp: ${hp}");
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is DoorArea) {
      standingInDoorArea = false;
    }
  }

  void setInvertedSprite() {
    this.sprite = this._invertedSprite;
  }

  void setStandardSprite() {
    this.sprite = this._standardSprite;
  }



  @override
  void update(double dt) {
    super.update(dt);
    setPlayerPosition(_moveDirection.normalized() * _speed * dt);
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

  void setPlayerPosition(Vector2 movementVector) {
    this.position += movementVector;
  }

}