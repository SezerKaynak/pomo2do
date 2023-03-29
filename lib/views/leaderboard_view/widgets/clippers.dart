import 'package:flutter/material.dart';

class RectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path = Path();

    path.lineTo(0, h);
    path.lineTo(w, h);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(RectangleClipper oldClipper) => false;
}

class FirstClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path = Path();

    path.moveTo(w - 80, 0);
    path.lineTo(0, h);
    path.lineTo(w, h);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(FirstClipper oldClipper) => false;
}

class MiddleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path = Path();

    path.moveTo(w - 90, 0);
    path.lineTo(0, h);
    path.lineTo(w, h);
    path.lineTo(w - 10, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(MiddleClipper oldClipper) => false;
}

class LastClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, h);
    path.lineTo(w, h);
    path.lineTo(w - 20, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(LastClipper oldClipper) => false;
}
