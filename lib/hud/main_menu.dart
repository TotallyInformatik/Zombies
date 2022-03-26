import 'dart:ui';

import 'package:cod_zombies_2d/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class MainMenu extends StatelessWidget {

  static const id = "MainMenu";

  final ZombiesGame gameRef;
  const MainMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
                "Zombies 2D",
                style: GoogleFonts.nanumBrushScript().copyWith(fontSize: 120, color: Colors.white)
            ),
          TextButton(
              onPressed: () {
                gameRef.startGame();
                gameRef.overlays.remove(MainMenu.id);
              },
              child: Text(
                  "Play",
                  style: GoogleFonts.nanumBrushScript().copyWith(fontSize: 100, color: Colors.red)
              ),
            )
          ]
      )
     )
    );
  }

}