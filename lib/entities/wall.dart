import 'package:vector_math/vector_math_64.dart';

import 'collidables.dart';

class Wall extends CollidableObject {
  Wall(Vector2 position, Vector2 size) : super(position, size);
}