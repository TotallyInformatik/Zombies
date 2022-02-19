import 'package:flame/components.dart';

mixin InteractiveArea on Collidable {

  late final String tooltip;
  void onInteract();

}