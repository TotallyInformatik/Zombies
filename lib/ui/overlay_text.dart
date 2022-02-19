import 'package:cod_zombies_2d/ui/overlay_component.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OverlayText extends TextComponent with OverlayComponent {

  static final _textRenderer = TextPaint(
      style: GoogleFonts.getFont("Patrick Hand SC")
          .copyWith(fontSize: 12, color: Colors.white)
  );

  OverlayText(String text, Vector2 position) : super(
    text: text,
    position: position,
    textRenderer: _textRenderer
  );

}