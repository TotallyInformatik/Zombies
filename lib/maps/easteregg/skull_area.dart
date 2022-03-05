import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/interactive_area.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class SkullArea extends SpriteComponent with HasHitboxes, Collidable, HasGameRef<ZombiesGame> implements InteractiveArea {

  @override
  int cost = 0;

  @override
  String tooltip = "";

  static int skullCount = 0;

  SkullArea(Vector2 position) : super(
      position: position,
      size: Vector2.all(20)
  ) {
    skullCount++;
  }

  @override
  Future<void>? onLoad() async {

    sprite = await Sprite.load("Skull.png");
    anchor = Anchor.center;
    collidableType = CollidableType.passive;
    addHitbox(HitboxRectangle(relation: Vector2(0.5, 0.5)));

    return super.onLoad();
  }

  @override
  void onInteract() {

    gameRef.player.skullCount++;
    removeFromParent();

    if (gameRef.player.skullCount == skullCount) {
      gameRef.ui.updateEasterEggDisplay("These Skulls... They seem to face south-east...").then((value)
        => gameRef.ui.updateEasterEggDisplay("Almost like they're guiding you..."));
    }

  }

}