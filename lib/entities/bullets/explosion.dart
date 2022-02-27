import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:flame/components.dart';

class Explosion extends SpriteAnimationComponent with HasGameRef<ZombiesGame> {
  Explosion(Vector2 srcPosition) : super(
      position: srcPosition,
  );

  static const double animationStepTime = 0.1;
  static const double maxExplosionDistance = 80;
  double explosionSize = 60;
  int damage = 3;

  @override
  Future<void>? onLoad() async {

    anchor = Anchor.center;
    size = Vector2.all(explosionSize);

    animation = SpriteAnimation.spriteList([
      await Sprite.load("Explosion1.png"),
      await Sprite.load("Explosion2.png"),
      await Sprite.load("Explosion3.png"),
      await Sprite.load("Explosion4.png")
    ], stepTime: Explosion.animationStepTime, loop: false);

    List<Zombie> zombiesThatAreGoingToDie = [];
    for (Zombie zombie in gameRef.allZombies) {
      if (distance(zombie) <= explosionSize / 2) {
        zombiesThatAreGoingToDie.add(zombie);
      }
    }

    for (Zombie zombie in zombiesThatAreGoingToDie) {
      zombie.processHit(damage);
    }
    zombiesThatAreGoingToDie.clear();

    int timeInMilliSeconds =  (animation!.frames.length * animationStepTime * 1000).toInt();
    Future.delayed(Duration(milliseconds: timeInMilliSeconds)).then((value) => {
      gameRef.remove(this)
    });

    return super.onLoad();
  }

}