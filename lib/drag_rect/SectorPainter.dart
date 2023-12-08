import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import '../src/gods/muses.dart';
import '../src/gods/world/line.dart';
import '../src/sector/sector.dart';

class SectorPainter extends StatefulWidget {
  const SectorPainter({Key? key}) : super(key: key);

  @override
  State<SectorPainter> createState() => _SectorPainterState();
}

class _SectorPainterState extends State<SectorPainter> {
  DragingTarget _dragging = DragingTarget.none; // 0 无拖拽 1拖拽梯形 2拖拽点
  var xPos = 0.0;
  var yPos = 0.0;

  double outRadius = 580;//外半径
  double innerRadius = 360;//内半径
  double minDiffRadius = 100;//最小半径差值
  double maxDiffRadius = 400;//最大半径差值
  double minInnerRadius = 270; // 内半径最小值
  double maxOutRadius = 700; // 内半径最小值

  double sweepAngle = 0.15 * pi; // 弧度
  double minSweepAngle = 0.05 * pi; // 最小弧度
  double startAngle = (pi / 2.4);//开始弧度
  Paper? paper;

  @override
  Widget build(BuildContext context) {
    paper = Paper(
        outRadius: outRadius,
        innerRadius: innerRadius,
        sweepAngle: sweepAngle,
        startAngle: startAngle);
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            GestureDetector(
              onPanStart: _onPanStart,
              onPanEnd: _onPanEnd,
              onPanUpdate: _onPanUpdate,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: CustomPaint(
                  painter: paper,
                ),
              ),
            ),
            Positioned(
                top: 40,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.orange,
                  child:Column(children: [
                    Text(_dragging == DragingTarget.none ?'停止拖拽':'正在拖拽${_dragging.toString()}'),
                    Text("xPos:${xPos}==yPos:${yPos}"),
                  ],),
                )),
          ],
        ),
      ),
    );
  }

  void _onPanStart(details) {
    setState(() {
      xPos = details.localPosition.dx;
      yPos = details.localPosition.dy;
      _dragging = _getDragingTarget(xPos, yPos);
      List<DragingTarget> vibratePoints =[DragingTarget.p0,DragingTarget.p1,DragingTarget.q0,DragingTarget.q1];
      if (vibratePoints.contains(_dragging)) {
        _vibratePhone();
      }
    });
  }

  void _onPanUpdate(details) {
    // x轴方向位移量
    var deltaX = details.delta.dx;
    // y轴方向位移量
    var deltaY = details.delta.dy;
    // 移动步长
    double stepSize = deltaX / 350;
    if (_dragging == DragingTarget.sector && _canContinueDrag(stepSize,deltaY)) {
      //拖动扇形
      setState(() {
        outRadius += deltaY;
        innerRadius += deltaY;
        startAngle -= stepSize;
      });
      return;
    }
    if (_dragging == DragingTarget.q0 && _canContinueDrag(stepSize,deltaY)) {
      //    拖动左上角点
      setState(() {
        sweepAngle -= stepSize;
        innerRadius += deltaY;
      });
      return;
    }
    if (_dragging == DragingTarget.p0 && _canContinueDrag(stepSize,deltaY)) {
      //    拖动右上角点
      setState(() {
        startAngle -= stepSize;
        sweepAngle += stepSize;
        innerRadius += deltaY;
      });
      return;
    }
    if (_dragging == DragingTarget.q1 && _canContinueDrag(stepSize,deltaY)) {
      //    拖动左下角点
      setState(() {
        sweepAngle -= stepSize;
        outRadius += deltaY;
      });
      return;
    }
    if (_dragging == DragingTarget.p1 && _canContinueDrag(stepSize,deltaY)) {
      //    拖动右下角点
      setState(() {
        sweepAngle += stepSize;
        startAngle -= stepSize;
        outRadius += deltaY;
      });
      return;
    }
  }

  void _onPanEnd(details) {
    setState(() {
      _dragging = DragingTarget.none;
      xPos = 0;
      yPos = 0;
    });
  }

  // 判断点击的坐标在那个位置
  DragingTarget _getDragingTarget(double x,double y){
    DragingTarget dragingTarget = DragingTarget.none;
    if(paper!.shape.contains(Offset(xPos, yPos))){
      dragingTarget =  DragingTarget.sector;
    }else{
      dragingTarget = paper!.shape.dragingDragPointer(xPos, yPos)??DragingTarget.none;
    }
    return dragingTarget;
  }

  bool _canContinueDrag(double stepSize,double deltaY){
    double leftBoundary = 8;
    double rightBoundary = paper!.shape.center.dx * 2 - 8;

    bool isAtTopP0Dy = paper!.shape.p0.dy <= sin(startAngle) * minInnerRadius ;
    bool isAtTopP1Dy = paper!.shape.p1.dy >= sin(startAngle) * maxOutRadius ;
    bool isAtTopQ0Dy = paper!.shape.q0.dy <= sin(startAngle + sweepAngle) * minInnerRadius ;
    bool isAtTopQ1Dy = paper!.shape.q1.dy >= sin(startAngle + sweepAngle) * maxOutRadius ;
    print("isAtTopP0Dy：${isAtTopP0Dy}  ${paper!.shape.p0.dy} , ${sin(startAngle) * minInnerRadius}");
    print("isAtTopP1Dy：${isAtTopP1Dy}");
    print("isAtTopQ0Dy：${isAtTopQ0Dy} ===${paper!.shape.q0.dy },${ sin(startAngle + sweepAngle) * minInnerRadius}");
    print("isAtTopQ1Dy：${isAtTopQ1Dy}");
    bool isAtLeftBoundary = paper!.shape.q1.dx <= leftBoundary;
    bool isAtRightBoundary = paper!.shape.p1.dx >= rightBoundary;
    bool isAtUpperRadiusBoundary = innerRadius <= minInnerRadius;
    bool isAtLowerRadiusBoundary = outRadius >= maxOutRadius;
    bool isBelowMinimumSize = outRadius - innerRadius <= minDiffRadius;
    bool isAboveMaximumSize = outRadius - innerRadius >= maxDiffRadius;
    bool isBelowMinimumSweepAngle = sweepAngle < minSweepAngle;
    // 控制梯形不超过屏幕左右边界
    if( isAtLeftBoundary && (stepSize<0 || deltaY>0)){
      print('扇形已到最左边界==========>');
      return false;
    }
    if( isAtRightBoundary && (stepSize>0 || deltaY>0)){
      print('扇形已到最右边界==========>');
      return false;
    }

    // 控制梯形不超过上下边界
    if((isAtTopQ0Dy || isAtTopP0Dy) && deltaY < 0){
      print('扇形已到最上边界==========>');
      return false;
    }
    if((isAtTopQ1Dy || isAtTopP1Dy) && deltaY >=0){
      print('扇形已到最下边界==========>');
      return false;
    }
    // 控制梯形大小maxDiffRadius
    if(isBelowMinimumSize){
      print('扇形小于最小大小==========>');
      if((_dragging == DragingTarget.q0||_dragging == DragingTarget.p0) && deltaY >= 0){
        return false;
      }else if((_dragging == DragingTarget.q1||_dragging == DragingTarget.p1) && deltaY <0){
        return false;
      }
    }
    if(isAboveMaximumSize){
      print('扇形大于最大大小==========>');
      if((_dragging == DragingTarget.q0||_dragging == DragingTarget.p0) && deltaY <0){
        return false;
      }else if((_dragging == DragingTarget.q1||_dragging == DragingTarget.p1) && deltaY >= 0){
        return false;
      }
    }
    // 控制梯形弧度
    if(isBelowMinimumSweepAngle){
      print('扇形小于最小弧度==========>');
      if(_dragging == DragingTarget.q0 && stepSize>0){
        return false;
      }
      if(_dragging == DragingTarget.p0 && stepSize<=0){
        return false;
      }
      if(_dragging == DragingTarget.q1 && stepSize>0){
        return false;
      }
      if(_dragging == DragingTarget.p1 && stepSize<=0){
        return false;
      }
    }
    // 控制梯形的上下位置
    if(_dragging == DragingTarget.sector){
      if(isAtUpperRadiusBoundary && deltaY<0){
        print('扇形整体已到最上边界==========>');
        return false;
      }
      if(isAtLowerRadiusBoundary && deltaY>0){
        print('扇形整体已到最下边界==========>');
        return false;
      }
    }
    return true;
  }

  void _vibratePhone() async {
    // 检查是否支持震动
    bool canVibrate = await Vibration.hasVibrator() ?? false;
    if (canVibrate) {
      // 触发手机震动
      Vibration.vibrate(duration: 100);
    } else {
      print('设备不支持震动');
    }
  }
}

class Paper extends CustomPainter {
  double outRadius;
  double sweepAngle;
  double startAngle;
  double innerRadius;

  Paper(
      {
      required this.outRadius,
      required this.innerRadius,
      required this.sweepAngle,
      required this.startAngle});

  Muses muses = Muses();
  late SectorShape shape;

  @override
  void paint(Canvas canvas, Size size) {
    //容器中心
    Offset center = Offset(size.width / 2, 0);

    /// 绘制扇形 和 拖拽点
    shape = SectorShape(
      center: center,
      innerRadius: innerRadius,
      outRadius: outRadius,
      startAngle: startAngle,
      sweepAngle: sweepAngle,
      canvas: canvas,
      size: size,
    );

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.transparent
      ..strokeWidth = 2;
    //扇形填充
    canvas.drawPath(shape.formPath(), paint);
    //扇形框框
    final Paint paint2 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(shape.formPath(), paint2);

    /// 绘制辅助线
    // 平移canvas坐标系
    canvas.translate(size.width / 2, 0);
    muses.attach(canvas);
    // /外圆
    muses.markCircle(Offset.zero, outRadius);
    // /内圆
    muses.markCircle(Offset.zero, innerRadius);
    // /结束线
    muses.markLine(Line.fromRad(start: Offset.zero, rad: startAngle, len: outRadius));
    // /开始线
    muses.markLine(Line.fromRad(start: Offset.zero, rad: startAngle + sweepAngle, len: outRadius));
  }

//  是否需要重新绘制(每次调用 paint 方法之前都会被调用)
  @override
  bool shouldRepaint(covariant Paper oldDelegate) {
    return true;
  }
}

