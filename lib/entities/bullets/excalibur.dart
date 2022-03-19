import 'dart:math';

import 'package:cod_zombies_2d/entities/bullets/bullet.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/interactive_area.dart';
import 'package:cod_zombies_2d/maps/weapons/weapon.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';

class Excalibur extends Bullet with Collidable implements InteractiveArea {
  @override
  int damage = 0;

  @override
  double speed = 0;

  int hpHeal = 1;
  static const int useDelayInSeconds = 20;
  int healDelayInMilliseconds = 2000;
  int maxHealCount = 3;
  int currentHealCount = 0;

  late NeatPeriodicTaskScheduler healTimer;

  @override
  int cost = 0;

  @override
  String tooltip = "Press F to pick up excalibur";

  @override
  void onInteract() {
    pickup();
  }


  pickup() async {
    removeFromParent();
    gameRef.player.changeWeapon(await excalibur());
  }

  Excalibur(Vector2 srcPosition) : super(srcPosition, Vector2(10, 30), Vector2.zero());

  @override
  Future<void>? onLoad() {

    anchor = Anchor.center;
    healTimer = NeatPeriodicTaskScheduler(
      interval: Duration(milliseconds: healDelayInMilliseconds),
      name: 'excalibur-timer',
      timeout: Duration(milliseconds: healDelayInMilliseconds ~/ 3),
      task: () async {
        _healPlayer();
      },
      minCycle: Duration(milliseconds: healDelayInMilliseconds ~/ 3),
    );
    healTimer.start();
    addHitbox(HitboxRectangle());


    Player player = gameRef.player;
    player.weapons.removeAt(player.currentActiveWeaponIndex);
    player.currentActiveWeaponIndex = 0;
    player.useExcalibur();
    gameRef.ui.updateWeapon();

    return super.onLoad();
  }

  _healPlayer() {

    if (currentHealCount >= maxHealCount) {
      healTimer.stop();
      return;
    }

    gameRef.player.updateHealth(1);
    currentHealCount++;
  }

  @override
  Future<void> loadHitbox() async {  }

  @override
  Future<void> loadSprite() async {
    sprite = await Sprite.load("WeaponExcalibur.png");
  }

}