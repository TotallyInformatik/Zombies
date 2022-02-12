import 'package:flame/components.dart';

class Test extends SpriteComponent {

  Test(Vector2 position) : super(position: position, size: Vector2.all(20));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    this.sprite = await Sprite.load('Knight.png');
  }

}