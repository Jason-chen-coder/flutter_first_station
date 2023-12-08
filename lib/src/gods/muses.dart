// 缪斯 - 希腊神话中主司艺术与科学的九位古老文艺女神的总称
import 'dart:math';

import 'package:flutter/material.dart';

import '../sector/sector.dart';
import 'world/dash_painter.dart';
import 'world/line.dart';

enum PaintType {
  fill,
  stork,
  daskStork,
}

class PaintAttr {
  final Color? color;
  final double? strokeWidth;

  PaintAttr({this.color, this.strokeWidth});

  void mergePaint(Paint paint) {
    paint.color = color ?? paint.color;
    paint.strokeWidth = strokeWidth ?? paint.strokeWidth;
  }
}

class Muses {
  Paint paint = Paint();
  DashPainter dashPainter = const DashPainter();

  late Canvas canvas;

  void attach(Canvas canvas) {
    this.canvas = canvas;
  }

  void markCircle(Offset center, double radius,
      {PaintType type = PaintType.daskStork, PaintAttr? attr}) {
    Paint paint = Paint();
    Path path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    if (attr != null) {
      attr.mergePaint(paint);
    }
    switch (type) {
      case PaintType.fill:
        paint.style = PaintingStyle.fill;
        canvas.drawPath(path, paint);
        break;
      case PaintType.stork:
        paint.style = PaintingStyle.stroke;
        canvas.drawPath(path, paint);
        break;
      case PaintType.daskStork:
        paint.style = PaintingStyle.stroke;
        paint.color = Colors.purpleAccent;
        dashPainter.paint(canvas, path, paint);
        break;
    }
  }

  void markLine(
    Line line, {
    Color color = Colors.red,
    bool close = true,
    String? start,
    String? end,
  }) {

    paint.color = color;
    if (close) {
      canvas.drawLine(line.start, line.end, paint);
    }
    // canvas.drawCircle(line.start, 4, paint..style = PaintingStyle.fill);
    // canvas.drawCircle(line.end, 4, paint..style = PaintingStyle.fill);

  }
}
