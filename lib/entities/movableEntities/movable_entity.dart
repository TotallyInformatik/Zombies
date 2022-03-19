import 'package:flame/components.dart';

mixin MoveableEntity on HasHitboxes, Collidable, SpriteAnimationComponent {

  void handleImmovableCollision(Set<Vector2> intersectionPoints) {
    if (intersectionPoints.length == 2) {
      final mid = ((intersectionPoints.elementAt(1) + intersectionPoints.elementAt(0)) / 2);

      final collisionNormal = absoluteCenter - mid;
      final seperationDistance = (size.x / 2) - collisionNormal.length;

      position += collisionNormal.normalized().scaled(seperationDistance * 1.1);
    }
  }

  void processHit(int dHealth);
  Future<void> setupAnimations();

}