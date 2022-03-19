
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/interactive_area.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class ExitArea extends SpriteComponent with HasHitboxes, Collidable, HasGameRef<ZombiesGame> implements InteractiveArea {

  @override
  int cost = 0;

  @override
  String tooltip = "";
  bool active = false;

  ExitArea(Vector2 position, Vector2 size) : super(
      position: position,
      size: size
  );

  @override
  onLoad() async {
    super.onLoad();

    collidableType = CollidableType.passive;
    sprite = await Sprite.load("Floor.png");
    addHitbox(HitboxRectangle());

  }

  activate() async {
    print("activating exit");
    tooltip = "press F to escape the Dungeon";
    active = true;
    sprite = await Sprite.load("FloorLadder.png");
  }

  @override
  void onInteract() {

    print("interacting");
    print(tooltip);
    if (!active) return;

    gameRef.endGame();
  }


}