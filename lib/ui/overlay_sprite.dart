import 'package:cod_zombies_2d/ui/overlay_component.dart';
import 'package:flame/components.dart';

class OverlaySprite extends SpriteComponent with OverlayComponent {

  OverlaySprite(Sprite sprite, Vector2 viewportPosition, double size) :
        super(
          sprite: sprite,
          position: viewportPosition,
          size: Vector2(size, size)
        );
  
}