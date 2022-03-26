import 'dart:ui';

import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/hud/main_menu.dart';
import 'package:cod_zombies_2d/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PauseMenu extends StatelessWidget {

  static String id = "PauseMenu";

  final ZombiesGame gameRef;

  const PauseMenu(this.gameRef, {Key? key}) : super(key: key);

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
                      "Game Paused",
                      style: GoogleFonts.nanumBrushScript().copyWith(fontSize: 120, color: Colors.white)
                  ),
                  TextButton(
                    onPressed: () {
                      gameRef.resumeEngine();
                      gameRef.overlays.remove(PauseMenu.id);
                    },
                    child: Text(
                        "Continue",
                        style: GoogleFonts.nanumBrushScript().copyWith(fontSize: 100, color: Colors.red)
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => GamePage()));
                    },
                    child: Text(
                        "Back to Main Menu",
                        style: GoogleFonts.nanumBrushScript().copyWith(fontSize: 100, color: Colors.red)
                    ),
                  )
                ]
            )
        )
    );
  }

}