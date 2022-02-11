import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class CollidableObject extends PositionComponent with HasHitboxes, Collidable {

  CollidableObject(
      Vector2 position,
      Vector2 size,
  ) : super(
      position: position,
      size: size
  );

  @override
  Future<void>? onLoad() {
    collidableType = CollidableType.passive;
    addHitbox(HitboxRectangle());
    return super.onLoad();
  }

}