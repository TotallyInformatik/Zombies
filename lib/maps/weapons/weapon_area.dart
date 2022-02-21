import 'package:cod_zombies_2d/entities/bullet.dart';
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

  @override
  void onInteract() {

    Player player = gameRef.player;

    if (player.points < cost) return;
    if (player.weapons.contains(weapon)) return;


    if (player.weapons.length == player.maxWeaponCount) {
      player.weapons[player.currentActiveWeaponIndex] = weapon;
    } else if (player.weapons.length < player.maxWeaponCount) {
      player.weapons.add(weapon);
    }

  }

}