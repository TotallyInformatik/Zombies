import 'package:flame/components.dart';

mixin OverlayComponent on Component {

  @override
  Future<void>? onLoad() {
    positionType = PositionType.viewport;
    return super.onLoad();
  }

}