import 'package:cod_zombies_2d/entities/bullets/bullet.dart';
import 'package:cod_zombies_2d/entities/collidables.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/interactive_area.dart';
import 'package:cod_zombies_2d/maps/weapons/weapon.dart';
import 'package:flame/components.dart';

class WeaponArea extends CollidableObject with Collidable, HasGameRef<ZombiesGame> implements InteractiveArea {

  final Weapon weapon;

  @override
  String tooltip;
  @override
  int cost;

  WeaponArea(Vector2 position, Vector2 size, this.weapon, this.cost, this.tooltip) : super(position, size);

  void setToolTipWhenOwned() {

    String standardTooltip = tooltip;

    tooltip = "Refill ammo? (${cost})";

    Future.delayed(const Duration(seconds: 1)).then((value) => {
      tooltip = standardTooltip
    });
  }

  @override
  void onInteract() async {

    Player player = gameRef.player;

    if (player.points < cost) return;
    if (player.weapons.contains(weapon)) {
      int indexOfWeapon = player.weapons.indexOf(weapon);
      Weapon playerWeapon = player.weapons[indexOfWeapon];
      playerWeapon.ammo = playerWeapon.maxAmmo;
      gameRef.ui.updateAmmo();
      return;
    }

    player.changePoints(-cost);
    player.changeWeapon(weapon);
    gameRef.ui.updateWeapon();
    setToolTipWhenOwned();

    if (weapon == await excalibur()) {
      removeFromParent();
    }

  }

}