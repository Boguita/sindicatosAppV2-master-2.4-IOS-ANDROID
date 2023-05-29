import 'package:flutter/material.dart';

class CustomTheme {
  static LinearGradient getBackgroundGradient() {
    return new LinearGradient(
        colors: [
          //Colors.blue[700],
          //Colors.blue[900]
          Colors.grey[300],
          Colors.grey[500]
        ],
        begin: const FractionalOffset(0.5, 0.0),
        end: const FractionalOffset(0.5, 0.5),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

  static LinearGradient getAntiBackgroundGradient() {
    return new LinearGradient(
        colors: [
          //Colors.blue[800],
          //Colors.blue[600]
          Colors.white,
          Colors.white
        ],
        begin: const FractionalOffset(0.5, 0.0),
        end: const FractionalOffset(0.5, 0.5),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }
}

final ThemeData CustomThemeData = new ThemeData(
  fontFamily: 'Montserrat',
  canvasColor: Colors.white,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Color(0xffBA379B).withOpacity(.5),
    cursorColor: Color(0xffBA379B).withOpacity(.03),
    selectionHandleColor: Color(0xffBA379B).withOpacity(1),
  ),
);
