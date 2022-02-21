import 'package:cod_zombies_2d/entities/bullet.dart';
import 'package:flame/components.dart';

class Weapon {
  final Sprite weaponSprite;
  final Bullet weaponBullet;
  final int weaponShootDelayInMiliseconds;

  Weapon(this.weaponSprite, this.weaponBullet, this.weaponShootDelayInMiliseconds);

}

Future<Weapon> starterWeapon() async {

  Sprite starterWeaponSprite = await Sprite.load("crosshair.png");
  return Weapon(
    starterWeaponSprite,
    Bullet(1, starterWeaponSprite, Vector2.all(5)),
    100
  );

}