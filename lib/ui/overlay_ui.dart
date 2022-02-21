import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/ui/overlay_sprite.dart';
import 'package:cod_zombies_2d/ui/overlay_text.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO: add ui for purchased perks

class OverlayUI extends Component with HasGameRef<ZombiesGame> {

  late final Sprite _fullHeartSprite;
  late final Sprite _emptyHeartSprite;
  late final OverlaySprite _coinSprite;
  late final OverlayText _pointsText;
  late final OverlayText _tooltip;

  final List<OverlaySprite> heartSprites = [];
  final double heartSize = 20;

  final double coinSize = 15;



  @override
  Future<void>? onLoad() {

    _setupOverlayUI();

    return super.onLoad();

  }

  void _setupOverlayUI() async {

    /// player hp
    _fullHeartSprite = await Sprite.load("HeartFull.png");
    _emptyHeartSprite = await Sprite.load("HeartEmpty.png");

    for (int i=0; i<5; i++) {
      OverlaySprite newHeartSprite =
        OverlaySprite(_fullHeartSprite, Vector2(i*heartSize, 0), heartSize);

      heartSprites.add(newHeartSprite);
    }
    updateMaximumHearts();


    /// player points
    _coinSprite =
      OverlaySprite(await Sprite.load("Coin.png"), Vector2(0, heartSize), coinSize);

    gameRef.add(_coinSprite);
    _pointsText = OverlayText(
        "Points: ${gameRef.player.points}",
        Vector2.all(heartSize)
    );

    _pointsText.positionType = PositionType.viewport;

    gameRef.add(_pointsText);


    /// tooltip
    _tooltip = OverlayText(
        "",
        Vector2(0, coinSize + heartSize)
    );
    gameRef.add(_tooltip);

  }

  void showTooltip(String tooltip) {
    _tooltip.text = tooltip;
  }

  void _setupGameOverOverlay() {

  }

  void updateMaximumHearts() {

    for (int i=0; i<heartSprites.length; i++) {
      gameRef.remove(heartSprites[i]);
    }

    for (int i=0; i<gameRef.player.maximumHealthPoints; i++) {
      gameRef.add(heartSprites[i]);
    }

  }

  void updateHearts(int hp) {

    for (int i=0; i<gameRef.player.maximumHealthPoints; i++) {
      heartSprites[i].sprite = _fullHeartSprite;
    }
    for (int i = hp; i<gameRef.player.maximumHealthPoints; i++) {
      heartSprites[i].sprite = _emptyHeartSprite;
    }

  }

  void updatePoints() {
    gameRef.remove(_pointsText);
    _pointsText.text = "Points: ${gameRef.player.points}";
    gameRef.add(_pointsText);
  }

}