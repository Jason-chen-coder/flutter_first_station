import 'dart:math';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class SectorTween extends Tween<SectorShape>{
  SectorTween({ super.begin, super.end });

  @override
  SectorShape lerp(double t) => SectorShape.lerp(begin!, end!, t);
}

class  SectorShape {
  Offset center; // 中心点
  double innerRadius; // 小圆半径
  double outRadius; // 大圆半径
  double startAngle; // 起始弧度
  double sweepAngle; // 扫描弧度
  Canvas canvas;
  Size size;

  Offset p0 = const Offset(0,0);
  Offset p1  = const Offset(0,0);
  Offset q0 = const Offset(0,0);
  Offset q1  = const Offset(0,0);
  double dragPointerRadius  = 8;
  SectorShape({
    required this.center,
    required this.innerRadius,
    required this.outRadius,
    required this.startAngle,
    required this.sweepAngle,
    required this.canvas,
    required this.size,
  });

  SectorShape copyWith({
    Offset? center,
    double? innerRadius,
    double? outRadius,
    double? startAngle,
    double? sweepAngle,
    Canvas? canvas,
    Size? size,
}){
    return SectorShape(
        center:center??this.center,
        innerRadius:innerRadius??this.innerRadius,
        outRadius:outRadius??this.outRadius,
        startAngle:startAngle??this.startAngle,
        sweepAngle:sweepAngle??this.sweepAngle,
        canvas:canvas??this.canvas,
        size:size??this.size,

    );
  }

  //给个坐标，查看是否在形状内
  @override
  bool contains(Offset p) {
    Offset position = p - center;
    // 校验环形区域
    double l = position.distance;
    bool inRing = l <= outRadius && l >= innerRadius;
    if (!inRing) return false;

    // 校验角度范围
    double a = position.direction;
    double endArg = startAngle + sweepAngle;
    double start = startAngle;
    if(sweepAngle>0){
      if(position.dx<0&&position.dy<0){
        a+=2*pi;
      }
      return a >= start && a <= endArg;
    }else{
      return a <= start && a >= endArg;
    }
  }

  Path formPath() {
    double startRad = startAngle;
    double endRad = startAngle + sweepAngle;
    double r0 = innerRadius;
    double r1 = outRadius;
    // 拖拽点偏移
    p0 = Offset(cos(startRad) * r0, sin(startRad) * r0).translate(center.dx, center.dy);
    p1 = Offset(cos(startRad) * r1, sin(startRad) * r1).translate(center.dx, center.dy);
    q0 = Offset(cos(endRad) * r0, sin(endRad) * r0).translate(center.dx, center.dy);
    q1 = Offset(cos(endRad) * r1, sin(endRad) * r1).translate(center.dx, center.dy);
    // 绘制拖拽点
    paintDragPointer(p0,p1,q0,q1);

    bool large = sweepAngle.abs() > pi;
    bool clockwise = sweepAngle > 0;

    Path path = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..arcToPoint(q1, radius: Radius.circular(r1), clockwise: clockwise, largeArc: large)
      ..lineTo(q0.dx, q0.dy)
      ..arcToPoint(p0, radius: Radius.circular(r0), clockwise: !clockwise, largeArc: large);
    return path;
  }

  paintDragPointer(Offset p0,Offset p1,Offset q0,Offset q1){
    final Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = const Color(0xff3FC0AA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    /// q0左上角
    canvas.drawOval(Rect.fromCircle(center: q0, radius: dragPointerRadius), fillPaint);
    canvas.drawOval(Rect.fromCircle(center: q0, radius: dragPointerRadius), borderPaint);
    /// q1左下角
    canvas.drawOval(Rect.fromCircle(center: q1, radius: dragPointerRadius), fillPaint);
    canvas.drawOval(Rect.fromCircle(center: q1, radius: dragPointerRadius), borderPaint);
    /// p0右上角
    canvas.drawOval(Rect.fromCircle(center: p0, radius:dragPointerRadius), fillPaint);
    canvas.drawOval(Rect.fromCircle(center: p0, radius:dragPointerRadius), borderPaint);
    /// p1右下角
    canvas.drawOval(Rect.fromCircle(center: p1, radius:dragPointerRadius), fillPaint);
    canvas.drawOval(Rect.fromCircle(center: p1, radius:dragPointerRadius), borderPaint);
  }

  DragingTarget? dragingDragPointer(double x,double y){
    DragingTarget? draging;
    if (isPointWithinRange(x, y, p0, dragPointerRadius)) {
      print('点了p0点=====》');
      draging = DragingTarget.p0;
    }
    if (isPointWithinRange(x, y, q0, dragPointerRadius)) {
      print('点了q0点=====》');
      draging = DragingTarget.q0;
    }
    if (isPointWithinRange(x, y, p1, dragPointerRadius)) {
      print('点了p1点=====》');
      draging = DragingTarget.p1;
    }
    if (isPointWithinRange(x, y, q1, dragPointerRadius)) {
      print('点了q1点=====》');
      draging = DragingTarget.q1;
    }

    return draging;
  }

  bool isPointWithinRange(double x, double y, Offset point, double radius) {
    double dxMax = point.dx + radius*2;
    double dxMin = point.dx - radius*2;
    double dyMax = point.dy + radius*2;
    double dyMin = point.dy - radius*2;

    return x.clamp(dxMin, dxMax) == x && y.clamp(dyMin, dyMax) == y;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectorShape &&
          runtimeType == other.runtimeType &&
          center == other.center &&
          innerRadius == other.innerRadius &&
          outRadius == other.outRadius &&
          startAngle == other.startAngle &&
          sweepAngle == other.sweepAngle;

  @override
  int get hashCode =>
      center.hashCode ^
      innerRadius.hashCode ^
      outRadius.hashCode ^
      startAngle.hashCode ^
      sweepAngle.hashCode;

  static SectorShape lerp(SectorShape begin, SectorShape end, double t) {
        return SectorShape(
            center: begin.center,
            innerRadius:begin.innerRadius,
            outRadius: begin.outRadius,
            startAngle: _lerpDouble(begin.startAngle,end.startAngle,t),
            sweepAngle: _lerpDouble(begin.sweepAngle,end.sweepAngle,t),
            canvas:begin.canvas,
            size:begin.size
        );
  }

  static double _lerpDouble(double a, double b, double t) {
    return a * (1.0 - t) + b * t;
  }
}
enum DragingTarget { none, screen, sector, q0, p0, q1, p1 }
