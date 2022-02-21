import 'package:cod_zombies_2d/entities/collidables.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/interactive_area.dart';
import 'package:flame/components.dart';

enum Perks {
  QUICK_REVIVE,
  MULE_KICK,
  JUGGERNOG,
  DOUBLE_TAP
}

abstract class PerkArea extends CollidableObject with Collidable, HasGameRef<ZombiesGame> implements InteractiveArea {

  @override
  String tooltip;
  abstract Perks perkType;

  PerkArea(Vector2 position, Vector2 size, this.tooltip) : super(position, size);

  @override
  void onInteract() {
    Player player = gameRef.player;

    player.changePoints(-cost);
    player.possessedPerks.add(perkType);

    gameRef.remove(this);
  }

}