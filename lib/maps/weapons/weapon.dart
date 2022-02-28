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

  @override
  bool operator ==(other) {
    return other is Weapon && other._weaponType == _weaponType;
  }

  Weapon(this.weaponSprite, this.weaponBullet, this.weaponShootDelayInMiliseconds, this._weaponType);


}

Future<Weapon> bow() async {

  Sprite starterWeaponSprite = await Sprite.load("WeaponBow.png");
  return Weapon(
    starterWeaponSprite,
    BulletTypes.ARROW,
    200,
    WeaponType.BOW
  );

}

Future<Weapon> spear() async {
  Sprite spearSprite = await Sprite.load("WeaponSpear.png");
  return Weapon(
    spearSprite,
    BulletTypes.SPEAR,
    300,
    WeaponType.SPEAR
  );
}

Future<Weapon> apprenticesStaff() async {
  Sprite staffSprite = await Sprite.load("WeaponGreenMagicStaff.png");
  return Weapon(
    staffSprite,
    BulletTypes.APPRENTICES_ORB,
    50,
    WeaponType.APPRENTICES_STAFF
  );
}

Future<Weapon> megumin() async {
  Sprite staffSprite = await Sprite.load("WeaponRedMagicStaff.png");
  return Weapon(
      staffSprite,
      BulletTypes.EXPLOSION,
      1000,
      WeaponType.MEGUMIN
  );
}

Future<Weapon> excalibur() async {
  Sprite excaliburSprite = await Sprite.load("WeaponExcalibur.png");
  return Weapon(
      excaliburSprite,
      BulletTypes.EXCALIBUR,
      0,
      WeaponType.EXCALIBUR
  );
}

Future<Weapon> skull() async {
  Sprite skullSprite = await Sprite.load("Skull.png");
  return Weapon(
    skullSprite,
    BulletTypes.SKULL,
    0,
    WeaponType.SKULL
  );
}