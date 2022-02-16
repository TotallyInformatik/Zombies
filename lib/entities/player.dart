import 'package:cod_zombies_2d/datastructures/pair.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/entities/zombies.dart';
import 'package:cod_zombies_2d/main.dart';
import 'package:cod_zombies_2d/maps/door.dart';
import 'package:cod_zombies_2d/maps/door_area.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

enum PlayerFaceDirection {
  LEFT,
  RIGHT
}

class Player extends SpriteAnimationComponent with HasGameRef<ZombiesGame>, HasHitboxes, Collidable {

  static final int spriteHeight = 28;
  static final int spriteWidth = 16;

  Vector2 _moveDirection = Vector2.zero();

  double _speed = 100;
  int hp = 3;
  bool _currentlyInvincible = false;

  bool standingInDoorArea = false;
  late DoorArea currentDoorArea;

  int points = 500;
  static final hitPointIncrease = 40;


  /// movement status
  bool _currentlyMoving = false;
  PlayerFaceDirection _currentFaceDirection = PlayerFaceDirection.RIGHT;


  /// animations
  late final SpriteAnimation _standardRunAnimation;
  late final SpriteAnimation _invertedRunAnimation;
  late final SpriteAnimation _standardIdleAnimation;
  late final SpriteAnimation _invertedIdleAnimation;

  late final Map<Pair<bool, PlayerFaceDirection>, SpriteAnimation> movementStatusToSpriteAnimation;

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

    List<Sprite> standardRunAnimationFrames = [
      await Sprite.load('KnightRun1.png'),
      await Sprite.load('KnightRun2.png'),
      await Sprite.load('KnightRun3.png'),
      await Sprite.load('KnightRun4.png')
    ];

    List<Sprite> invertedRunAnimationFrames = [
      await Sprite.load('KnightRunInverted1.png'),
      await Sprite.load('KnightRunInverted2.png'),
      await Sprite.load('KnightRunInverted3.png'),
      await Sprite.load('KnightRunInverted4.png')
    ];

    List<Sprite> standardIdleAnimationFrames = [
      await Sprite.load('KnightIdle1.png'),
      await Sprite.load('KnightIdle2.png'),
      await Sprite.load('KnightIdle3.png'),
      await Sprite.load('KnightIdle4.png')
    ];

    List<Sprite> invertedIdleAnimationFrames = [
      await Sprite.load('KnightIdleInverted1.png'),
      await Sprite.load('KnightIdleInverted2.png'),
      await Sprite.load('KnightIdleInverted3.png'),
      await Sprite.load('KnightIdleInverted4.png')
    ];

    this._standardRunAnimation = SpriteAnimation.spriteList(standardRunAnimationFrames, stepTime: 0.2);
    this._invertedRunAnimation = SpriteAnimation.spriteList(invertedRunAnimationFrames, stepTime: 0.2);
    this._standardIdleAnimation = SpriteAnimation.spriteList(standardIdleAnimationFrames, stepTime: 0.3);
    this._invertedIdleAnimation = SpriteAnimation.spriteList(invertedIdleAnimationFrames, stepTime: 0.3);


    movementStatusToSpriteAnimation = {
      Pair(true, PlayerFaceDirection.RIGHT): _standardRunAnimation,
      Pair(true, PlayerFaceDirection.LEFT): _invertedRunAnimation,
      Pair(false, PlayerFaceDirection.RIGHT): _standardIdleAnimation,
      Pair(false, PlayerFaceDirection.LEFT): _invertedIdleAnimation,
    };

    this.animation = this._standardIdleAnimation;

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

  void setAnimation() {
    animation = movementStatusToSpriteAnimation[Pair<bool, PlayerFaceDirection>(_currentlyMoving, _currentFaceDirection)];
    print(movementStatusToSpriteAnimation.entries.first.key);
    print(Pair(_currentlyMoving, _currentFaceDirection));
  }

  void setFaceDirection(PlayerFaceDirection faceDirection) {
    if (_currentFaceDirection != faceDirection) {
      _currentFaceDirection = faceDirection;
      setAnimation();
    }
  }

  void setCurrentlyMoving(bool currentlyMoving) {
    if (_currentlyMoving != currentlyMoving) {
      _currentlyMoving = currentlyMoving;
      setAnimation();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    setPlayerPosition(_moveDirection.normalized() * _speed * dt);
  }

  void move(Set<LogicalKeyboardKey> keysPressed) {
    setCurrentlyMoving(true);

    Vector2 playerMoveDirection = new Vector2(0, 0);

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) { playerMoveDirection.y -= 1; }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) { playerMoveDirection.y += 1; }

    if (keysPressed.contains(LogicalKeyboardKey.keyD)) { playerMoveDirection.x += 1; }
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) { playerMoveDirection.x -= 1; }

    _moveDirection = playerMoveDirection;

  }

  void stop(LogicalKeyboardKey key) {
    setCurrentlyMoving(false);

    Vector2 currentPlayerMoveDirection = _moveDirection;

    if (key == LogicalKeyboardKey.keyW) { currentPlayerMoveDirection.y += 1; }
    if (key == LogicalKeyboardKey.keyS) { currentPlayerMoveDirection.y -= 1; }

    if (key == LogicalKeyboardKey.keyA) { currentPlayerMoveDirection.x += 1; }
    if (key == LogicalKeyboardKey.keyD) { currentPlayerMoveDirection.x -= 1; }

    _moveDirection = currentPlayerMoveDirection;
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }

  Vector2 getMoveDirection() { return _moveDirection; }

  void setPlayerPosition(Vector2 movementVector) {
    position += movementVector;
  }

}