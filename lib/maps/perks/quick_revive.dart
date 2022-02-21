import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/maps/perks/perk_area.dart';
import 'package:vector_math/vector_math_64.dart';

class QuickRevive extends PerkArea {

  @override
  Perks perkType = Perks.QUICK_REVIVE;

  @override
  int cost = 500;


  QuickRevive(Vector2 position, Vector2 size) :
        super(position, size, "Press F to buy Quick Revive (500)");

  @override
  void onInteract() {
    Player player = gameRef.player;

    if (player.points < cost) return;
    if (player.possessedPerks.contains(perkType)) return;

    super.onInteract();
  }
}