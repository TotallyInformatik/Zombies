import 'package:cod_zombies_2d/datastructures/pair.dart';
import 'package:cod_zombies_2d/entities/bullets/bullet.dart';
import 'package:cod_zombies_2d/entities/bullets/excalibur.dart';
import 'package:cod_zombies_2d/entities/bullets/explosion.dart';
import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_ice.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_tnt.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:cod_zombies_2d/maps/door/door_area.dart';
import 'package:cod_zombies_2d/maps/interactive_area.dart';
import 'package:cod_zombies_2d/maps/perks/perk_area.dart';
import 'package:cod_zombies_2d/maps/weapons/weapon.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';

enum PlayerFaceDirection {
  LEFT,
  RIGHT
}

class Player extends SpriteAnimationComponent with HasGameRef<ZombiesGame>, HasHitboxes, Collidable, MoveableEntity {

  static const int spriteHeight = 28;
  static const int spriteWidth = 16;

  static const hitPointIncrease = 40;


  /// player game attributes
  double _speed = 80;
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
  bool _canShoot = true;
  bool _canUseExcalibur = true;

  /// easter egg

  int skullCount = 0;

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


  @override
  Future<void> setupAnimations() async {


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

  }

  @override
  Future<void> onLoad() async {

    await setupAnimations();

    movementStatusToSpriteAnimation = {
      Pair(true, PlayerFaceDirection.RIGHT): _standardRunAnimation,
      Pair(true, PlayerFaceDirection.LEFT): _invertedRunAnimation,
      Pair(false, PlayerFaceDirection.RIGHT): _standardIdleAnimation,
      Pair(false, PlayerFaceDirection.LEFT): _invertedIdleAnimation,
    };

    anchor = Anchor.center;

    weapons.add(await bow());
    gameRef.ui.updateWeapon();

    addHitbox(HitboxCircle(position: Vector2(100, 100)));

    gameRef.gameStatus = GameStatus.PLAYING;
    return super.onLoad();
  }

  Future<void> invincibilityFrames() async {
    Future.delayed(const Duration(seconds: 1), () {
      _currentlyInvincible = false;
    });
  }

  void useExcalibur() {
    _canUseExcalibur = false;
    Future.delayed(const Duration(seconds: Excalibur.useDelayInSeconds)).then((value) => _canUseExcalibur = true);
  }

  @override
  void processHit(int dHealth) {
    updateHealth(-dHealth);
  }

  @override
  void updateHealth(int dHealth) {
    currentHealthPoints += dHealth;
    gameRef.ui.updateHearts(currentHealthPoints);
    _currentlyInvincible = true;
    invincibilityFrames();

    if (currentHealthPoints <= 0) {
      die();
    }

  }


  void revive() {
    possessedPerks.clear();
    deactivateJuggernog();
    maxWeaponCount = 2;
    currentActiveWeaponIndex = 0;
    gameRef.ui.updateWeapon();
    if (weapons.length == 3) {
      weapons.remove(weapons[2]);
    }
  }
  
  void changeWeapon(Weapon weapon) {
    if (weapons.length >= maxWeaponCount) {
      weapons[currentActiveWeaponIndex] = weapon;
    } else if (weapons.length < maxWeaponCount) {
      weapons.add(weapon);
    }
  }

  void die() {

    if (possessedPerks.contains(Perks.QUICK_REVIVE)) {
      gameRef.ui.deactivatePerks();
      revive();
      return;
    }

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
    } else if (other is Zombie && other is! ZombieIce && other is! ZombieTNT) {
      if (!_currentlyInvincible) {
        updateHealth(-1);
      }
    }
    else if (other is ZombieTNT) {
      if (!_currentlyInvincible) {
        if(currentHealthPoints <= 4) {
          die();
        }
        else {
          updateHealth(-4);
        }
      }
    }
    else if(other is ZombieIce){
      _speed = 40;
      Future.delayed(const Duration(seconds: 2), () {
        _speed = 80;
      });
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

  void switchWeapons(Set<LogicalKeyboardKey> pressedKeys) {

    if (pressedKeys.contains(LogicalKeyboardKey.digit1)) {
      currentActiveWeaponIndex = 0;
    } else if (pressedKeys.contains(LogicalKeyboardKey.digit2)) {
      currentActiveWeaponIndex = 1;
    } else if (pressedKeys.contains(LogicalKeyboardKey.digit3)) {
      currentActiveWeaponIndex = 2;
    }

    if (weapons.length < currentActiveWeaponIndex + 1) {
      currentActiveWeaponIndex = weapons.length - 1;
    }

    gameRef.ui.updateWeapon();

  }

  /// this function is called after the player successfully shoots, so as
  /// to delay the next shot via the [_canShoot] attribute
  Future<void> delayNextShot() async {

    Future.delayed(Duration(milliseconds: weapons[currentActiveWeaponIndex].weaponShootDelayInMiliseconds))
        .then((value) => {
          _canShoot = true
    });
  }

  void shoot(Vector2 tapPosition) async {

    if (!_canShoot) return;
    if (weapons[currentActiveWeaponIndex].ammo <= 0) return;

    BulletTypes bulletType = weapons[currentActiveWeaponIndex].weaponBullet;


    weapons[currentActiveWeaponIndex].shoot();
    gameRef.ui.updateAmmo();

    switch (bulletType) {

      case BulletTypes.ARROW:
      case BulletTypes.SPEAR:
      case BulletTypes.APPRENTICES_ORB:

        Vector2 bulletMovementVector = Vector2(
            tapPosition.x - x,
            tapPosition.y - y
        );
        gameRef.add(returnBulletFromBulletType(bulletType, position, bulletMovementVector.normalized(), tapPosition)!);

        break;
      case BulletTypes.EXPLOSION:

        Vector2 deltaVector = tapPosition - position;

        if (deltaVector.length > Explosion.maxExplosionDistance) {
          tapPosition = position + deltaVector.normalized() * Explosion.maxExplosionDistance;
        }

        gameRef.add(Explosion(tapPosition));

        break;
      case BulletTypes.EXCALIBUR:

        if (!_canUseExcalibur) {
          gameRef.ui.updateEasterEggDisplay("You can't use excalibur yet...");
          return;
        }
        gameRef.add(Excalibur(position));

        break;
    }
    _canShoot = false;
    delayNextShot();

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

    Vector2 playerMoveDirection = Vector2(0, 0);

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) { playerMoveDirection.y -= 1; }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) { playerMoveDirection.y += 1; }

    if (keysPressed.contains(LogicalKeyboardKey.keyD)) { playerMoveDirection.x += 1; }
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) { playerMoveDirection.x -= 1; }

    _moveDirection = playerMoveDirection;

  }

  void stop(LogicalKeyboardKey key, Set<LogicalKeyboardKey> keysPressed) {

    if (!keysPressed.contains(LogicalKeyboardKey.keyW) &&
        !keysPressed.contains(LogicalKeyboardKey.keyS) &&
        !keysPressed.contains(LogicalKeyboardKey.keyA) &
        !keysPressed.contains(LogicalKeyboardKey.keyD)) {
      setCurrentlyMoving(false);
    }



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