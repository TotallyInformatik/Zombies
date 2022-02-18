import 'package:flame/components.dart';

class OverlaySprite extends SpriteComponent {

  OverlaySprite(Sprite sprite, Vector2 viewportPosition, double size) :
        super(
          sprite: sprite,
          position: viewportPosition,
          size: Vector2(size, size)
        );

  @override
  Future<void>? onLoad() {
    positionType = PositionType.viewport;
    return super.onLoad();
  }

}