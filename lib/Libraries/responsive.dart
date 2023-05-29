import 'package:flutter/material.dart';
import 'dart:math';

class Responsive {
  Responsive(final BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
    _diagonal = sqrt(pow(_width, 2) + pow(_height, 2));
  }

  double getWidth() => _width;
  double getHeight() => _height;
  double getDiagonal() => _diagonal;

  double getWidthPercentage(final double percentage) => _width * percentage / 100.0;
  double getHeightPercentage(final double percentage) => _height * percentage / 100.0;
  double getDiagonalPercentage(final double percentage) => _diagonal * percentage / 100.0;

  double _width = 0.0;
  double _height = 0.0;
  double _diagonal = 0.0;
}
