import 'package:cod_zombies_2d/entities/bullets/bullet.dart';
import 'package:flame/components.dart';

enum WeaponType {
  BOW,
  SPEAR,
  APPRENTICES_STAFF,
  MEGUMIN,
  EXCALIBUR,
  SKULL
}

class Weapon {
  final WeaponType _weaponType;
  final Sprite weaponSprite;
  final BulletTypes weaponBullet;
  final int weaponShootDelayInMiliseconds;

  late int ammo;
  int maxAmmo;

  @override
  bool operator ==(other) {
    return other is Weapon && other._weaponType == _weaponType;
  }

  Weapon(this.weaponSprite, this.weaponBullet, this.weaponShootDelayInMiliseconds, this._weaponType, this.maxAmmo) {
    ammo = maxAmmo;
  }

  shoot() {
    ammo--;
  }

}

Future<Weapon> bow() async {

  Sprite starterWeaponSprite = await Sprite.load("WeaponBow.png");
  return Weapon(
    starterWeaponSprite,
    BulletTypes.ARROW,
    200,
    WeaponType.BOW,
    50
  );

}

Future<Weapon> spear() async {
  Sprite spearSprite = await Sprite.load("WeaponSpear.png");
  return Weapon(
    spearSprite,
    BulletTypes.SPEAR,
    300,
    WeaponType.SPEAR,
    50
  );
}

Future<Weapon> apprenticesStaff() async {
  Sprite staffSprite = await Sprite.load("WeaponGreenMagicStaff.png");
  return Weapon(
    staffSprite,
    BulletTypes.APPRENTICES_ORB,
    50,
    WeaponType.APPRENTICES_STAFF,
    200
  );
}

Future<Weapon> megumin() async {
  Sprite staffSprite = await Sprite.load("WeaponRedMagicStaff.png");
  return Weapon(
      staffSprite,
      BulletTypes.EXPLOSION,
      1000,
      WeaponType.MEGUMIN,
      20
  );
}

Future<Weapon> excalibur() async {
  Sprite excaliburSprite = await Sprite.load("WeaponExcalibur.png");
  return Weapon(
      excaliburSprite,
      BulletTypes.EXCALIBUR,
      0,
      WeaponType.EXCALIBUR,
      1
  );
}