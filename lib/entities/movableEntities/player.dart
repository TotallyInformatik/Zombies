import 'package:cod_zombies_2d/datastructures/pair.dart';
import 'package:cod_zombies_2d/entities/bullet.dart';
import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:cod_zombies_2d/maps/door/door_area.dart';
import 'package:cod_zombies_2d/maps/interactive_area.dart';
import 'package:cod_zombies_2d/maps/perks/perk_area.dart';
import 'package:cod_zombies_2d/maps/weapons/weapon.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

enum PlayerFaceDirection {
  LEFT,
  RIGHT
}

class Player extends SpriteAnimationComponent with HasGameRef<ZombiesGame>, HasHitboxes, Collidable, MoveableEntity {

  static final int spriteHeight = 28;
  static final int spriteWidth = 16;

  static final hitPointIncrease = 40;


  /// player game attributes
  final double _speed = 80;
  int playerDamageFactor = 1;
  int points = 500;

  /// health
  int maximumHealthPoints = 3;
  int currentHealthPoints = 3;
  bool _currentlyInvincible = false;

  InteractiveArea? currentArea;

  /// perks
  List<Perks> possessedPerks = [];

  /// weapons
  int maxWeaponCount = 2;
  int currentActiveWeaponIndex = 0;
  List<Weapon> weapons = [];


  /// movement status
  Vector2 _moveDirection = Vector2.zero();
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

    _standardRunAnimation = SpriteAnimation.spriteList(standardRunAnimationFrames, stepTime: 0.2);
    _invertedRunAnimation = SpriteAnimation.spriteList(invertedRunAnimationFrames, stepTime: 0.2);
    _standardIdleAnimation = SpriteAnimation.spriteList(standardIdleAnimationFrames, stepTime: 0.3);
    _invertedIdleAnimation = SpriteAnimation.spriteList(invertedIdleAnimationFrames, stepTime: 0.3);

    animation = _standardIdleAnimation;



    movementStatusToSpriteAnimation = {
      Pair(true, PlayerFaceDirection.RIGHT): _standardRunAnimation,
      Pair(true, PlayerFaceDirection.LEFT): _invertedRunAnimation,
      Pair(false, PlayerFaceDirection.RIGHT): _standardIdleAnimation,
      Pair(false, PlayerFaceDirection.LEFT): _invertedIdleAnimation,
    };

    anchor = Anchor.center;

    weapons.add(await starterWeapon());

    addHitbox(HitboxCircle(position: Vector2(100, 100)));


    return super.onLoad();
  }

  Future<void> invincibilityFrames() async {
    Future.delayed(const Duration(seconds: 1), () {
      _currentlyInvincible = false;
    });
  }

  @override
  void processHit(int dHealth) {
    currentHealthPoints -= dHealth;
    gameRef.ui.updateHearts(currentHealthPoints);
    _currentlyInvincible = true;
    invincibilityFrames();

    if (currentHealthPoints == 0) {
      die();
    }

  }


  void revive() {
    possessedPerks.clear();
    deactivateJuggernog();
  }

  void die() {

    if (possessedPerks.contains(Perks.QUICK_REVIVE)) {
      revive();
      return;
    }

    // TODO: set player animation to hit sprite
    gameRef.endGame();

  }

  void enterArea(InteractiveArea area) {
    currentArea = area;
    gameRef.ui.showTooltip(area.tooltip);
  }

  void exitArea() {
    currentArea = null;
    gameRef.ui.showTooltip("");
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {

    if (other is Door || other is Wall) {
      handleImmovableCollision(intersectionPoints);
    } else if (other is InteractiveArea) {
      enterArea(other);
    } else if (other is Zombie) {
      if (!_currentlyInvincible) {
        processHit(1);
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is InteractiveArea) {
      exitArea();
    }
  }

  void use() {

    if (currentArea == null) return;

    if (currentArea is InteractiveArea) {
      currentArea!.onInteract();
      exitArea();
    }
  }

  void shoot(Vector2 tapPosition) async {
    Vector2 bulletMovementVector = Vector2(
        tapPosition.x - x,
        tapPosition.y - y
    );

    // TODO: this does not work... must make individual classes for specific instantiation of bullets
    Bullet bullet = weapons[currentActiveWeaponIndex].weaponBullet;
    gameRef.add(bullet);
    bullet.onAdd(bulletMovementVector.normalized());

  }

  void changePoints(int dPoints) {
    points += dPoints;
    gameRef.ui.updatePoints();
  }

  void setAnimation() {
    animation = movementStatusToSpriteAnimation[Pair<bool, PlayerFaceDirection>(_currentlyMoving, _currentFaceDirection)];
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

    if (gameRef.gameStatus == GameStatus.GAMEOVER) return;

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

  /// perks
  void activateJuggernog() {
    currentHealthPoints = 5;
    maximumHealthPoints = 5;
    gameRef.ui.updateMaximumHearts();
    gameRef.ui.updateHearts(currentHealthPoints);
  }
  void deactivateJuggernog() {
    currentHealthPoints = 3;
    maximumHealthPoints = 3;
    gameRef.ui.updateMaximumHearts();
    gameRef.ui.updateHearts(currentHealthPoints);
  }


}