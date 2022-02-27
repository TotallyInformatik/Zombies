import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/maps/perks/perk_area.dart';
import 'package:flame/components.dart';

class Juggernog extends PerkArea {

  @override
  Perks perkType = Perks.JUGGERNOG;

  @override
  int cost = 3000;


  Juggernog(Vector2 position, Vector2 size) :
        super(position, size, "Press F to buy Juggernog (3000)");

  @override
  void onInteract() {
    Player player = gameRef.player;

    if (player.points < cost) return;

    super.onInteract();
    player.activateJuggernog();
  }
}