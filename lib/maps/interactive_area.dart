import 'package:flame/components.dart';

mixin InteractiveArea on Collidable {

  late final String tooltip;
  late final int cost;
  void onInteract();

}