import 'package:cod_zombies_2d/entities/bullets/arrow.dart';
import 'package:cod_zombies_2d/entities/bullets/bullet.dart';
import 'package:flame/components.dart';

class Weapon {
  final Sprite weaponSprite;
  final BulletTypes weaponBullet;
  final int weaponShootDelayInMiliseconds;

  Weapon(this.weaponSprite, this.weaponBullet, this.weaponShootDelayInMiliseconds);

}

Future<Weapon> starterWeapon() async {

  Sprite starterWeaponSprite = await Sprite.load("crosshair.png");
  return Weapon(
    starterWeaponSprite,
    BulletTypes.ARROW,
    100
  );

}