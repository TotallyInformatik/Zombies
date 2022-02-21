import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/maps/perks/perk_area.dart';
import 'package:flame/components.dart';

class DoubleTap extends PerkArea {

  @override
  Perks perkType = Perks.DOUBLE_TAP;

  @override
  int cost = 2000;


  DoubleTap(Vector2 position, Vector2 size) :
        super(position, size, "Press F to buy Double Tap (2000)");

  @override
  void onInteract() {
    Player player = gameRef.player;

    if (player.points < cost) return;
    if (player.possessedPerks.contains(perkType)) return;

    player.playerDamageFactor = 2;
    super.onInteract();
  }
}