import 'package:cod_zombies_2d/entities/bullet.dart';
import 'package:cod_zombies_2d/entities/collidables.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/interactive_area.dart';
import 'package:flame/components.dart';

abstract class WeaponArea extends CollidableObject with Collidable, HasGameRef<ZombiesGame> implements InteractiveArea {

  final Sprite weaponSprite;
  final Bullet weaponBullet;
  final int weaponShootDelayInMiliseconds;

  WeaponArea(Vector2 position, Vector2 size, this.weaponSprite, this.weaponBullet, this.weaponShootDelayInMiliseconds) : super(position, size);

}