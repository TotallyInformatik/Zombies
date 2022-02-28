import 'package:cod_zombies_2d/maps/weapons/weapon.dart';
import 'package:cod_zombies_2d/maps/weapons/weapon_area.dart';
import 'package:vector_math/vector_math_64.dart';

late Weapon skullWeapon;
Future<void> getSkullWeapon() async {
  skullWeapon = await skull();
}



class SkullCraftingArea extends WeaponArea {

  SkullCraftingArea(Vector2 position, Vector2 size) :
      super(
        position,
        size,
        skullWeapon,
        0,
        ""
      );


}