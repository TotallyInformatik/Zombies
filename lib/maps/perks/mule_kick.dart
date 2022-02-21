import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/maps/perks/perk_area.dart';
import 'package:flame/components.dart';

class MuleKick extends PerkArea {

  @override
  Perks perkType = Perks.MULE_KICK;

  @override
  int cost = 3000;


  MuleKick(Vector2 position, Vector2 size) :
        super(position, size, "Press F to buy Mule Kick (3000)");

  @override
  void onInteract() {
    Player player = gameRef.player;

    if (player.points < cost) return;
    if (player.possessedPerks.contains(perkType)) return;

    player.maxWeaponCount = 3;
    super.onInteract();
  }
}