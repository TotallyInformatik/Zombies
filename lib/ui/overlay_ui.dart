import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/ui/overlay_sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OverlayUI extends Component with HasGameRef<ZombiesGame> {

  late final Sprite _fullHeartSprite;
  late final Sprite _emptyHeartSprite;
  late final OverlaySprite _coinSprite;
  late final TextComponent _pointsText;

  final List<OverlaySprite> heartSprites = [];
  final double heartSize = 20;

  final double coinSize = 15;
  final TextPaint _textRenderer = TextPaint(style: GoogleFonts.getFont("Patrick Hand SC").copyWith(fontSize: 12, color: Colors.white));


  @override
  Future<void>? onLoad() {

    _setupOverlayUI();

    return super.onLoad();

  }

  void _setupOverlayUI() async {

    _fullHeartSprite = await Sprite.load("HeartFull.png");
    _emptyHeartSprite = await Sprite.load("HeartEmpty.png");

    for (int i=0; i<3; i++) {
      OverlaySprite newHeartSprite =
        OverlaySprite(_fullHeartSprite, Vector2(i*heartSize, 0), heartSize);

      heartSprites.add(newHeartSprite);
      gameRef.add(newHeartSprite);
    }

    _coinSprite =
      OverlaySprite(await Sprite.load("Coin.png"), Vector2(0, heartSize), coinSize);

    gameRef.add(_coinSprite);


    _pointsText =
      TextComponent(
        text: "Points: ${gameRef.player.points}",
        position: Vector2(heartSize, heartSize),
        textRenderer: _textRenderer
      );

    _pointsText.positionType = PositionType.viewport;
    _pointsText.anchor = Anchor.topLeft;

    gameRef.add(_pointsText);

  }

  void _setupGameOverOverlay() {

  }

  void updateHearts(int hp) {
    for (int i = hp; i<3; i++) {
      heartSprites[i].sprite = _emptyHeartSprite;
    }
  }

  void updatePoints() {
    gameRef.remove(_pointsText);
    _pointsText.text = "Points: ${gameRef.player.points}";
    gameRef.add(_pointsText);
  }

}