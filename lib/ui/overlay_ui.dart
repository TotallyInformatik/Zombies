import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/perks/perk_area.dart';
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

  late final OverlaySprite _quickReviveFlask;
  late final OverlaySprite _juggernogFlask;
  late final OverlaySprite _doubleTapFlask;
  late final OverlaySprite _muleKickFlask;
  final double flaskSize = 20;

  late final OverlaySprite _weaponSprite;
  final double weaponSize = 40;

  final List<OverlaySprite> heartSprites = [];
  final double heartSize = 20;

  final double coinSize = 15;

  late final OverlayText  _roundsText;

  late final OverlayText _easterEggDisplay;




  @override
  Future<void>? onLoad() {

    _setupOverlayUI();

    return super.onLoad();

  }

  void _setupOverlayUI() async {

    double viewportSizeX = gameRef.viewportDimensions.x;
    double viewportSizeY = gameRef.viewportDimensions.y;

    /// round display
    _roundsText = OverlayText(
        "",
        Vector2(10, viewportSizeY - 2*20)
    );
    _roundsText.textRenderer = TextPaint(
        style: GoogleFonts.nanumBrushScript()
            .copyWith(fontSize: 20, color: Colors.red));
    _roundsText.positionType = PositionType.viewport;

    gameRef.add(_roundsText);

    /// easter egg displays
    _easterEggDisplay = OverlayText(
        "",
        Vector2(viewportSizeX / 2 + 10, viewportSizeY / 2 - 10)
    );
    _easterEggDisplay.positionType = PositionType.viewport;
    gameRef.add(_easterEggDisplay);

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

    /// perks
    _quickReviveFlask = OverlaySprite(await Sprite.load("QuickReviveFlask.png"), Vector2(viewportSizeX - flaskSize * 4, 0), flaskSize);
    _juggernogFlask = OverlaySprite(await Sprite.load("JuggernogFlask.png"), Vector2(viewportSizeX - flaskSize * 3, 0), flaskSize);
    _doubleTapFlask = OverlaySprite(await Sprite.load("DoubleTapFlask.png"), Vector2(viewportSizeX - flaskSize * 2, 0), flaskSize);
    _muleKickFlask = OverlaySprite(await Sprite.load("MuleKickFlask.png"), Vector2(viewportSizeX - flaskSize * 1, 0), flaskSize);

    /// weapons
    _weaponSprite = OverlaySprite(await Sprite.load("WeaponBow.png"), Vector2(viewportSizeX - weaponSize, viewportSizeY - weaponSize), weaponSize);
    _weaponSprite.size = _weaponSprite.sprite!.originalSize;
    gameRef.add(_weaponSprite);

  }

  Future<void> updateEasterEggDisplay(String text) async {
    _easterEggDisplay.text = text;
    await Future.delayed(const Duration(seconds: 3)).then((value) => _easterEggDisplay.text = "");
  }

  void updateRound(int round) {
    _roundsText.text = "$round";
  }

  void showTooltip(String tooltip) {
    _tooltip.text = tooltip;
  }

  void updateWeapon() {
    Player player = gameRef.player;
    _weaponSprite.sprite = player.weapons[player.currentActiveWeaponIndex].weaponSprite;
    _weaponSprite.size = _weaponSprite.sprite!.originalSize;
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

  void activatePerk(Perks perkType) {

    switch (perkType) {

      case Perks.QUICK_REVIVE:
        gameRef.add(_quickReviveFlask);
        break;
      case Perks.MULE_KICK:
        gameRef.add(_muleKickFlask);
        break;
      case Perks.JUGGERNOG:
        gameRef.add(_juggernogFlask);
        break;
      case Perks.DOUBLE_TAP:
        gameRef.add(_doubleTapFlask);
        break;

    }

  }

  void deactivatePerks() {
    gameRef.remove(_quickReviveFlask);
    gameRef.remove(_juggernogFlask);
    gameRef.remove(_doubleTapFlask);
    gameRef.remove(_muleKickFlask);
  }

}