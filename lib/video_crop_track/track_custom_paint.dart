import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './video_track_painter.dart';

class TrackCustomPaint extends CustomPaint {
  const TrackCustomPaint({
    Key? key,
    CustomPainter? painter,
    CustomPainter? foregroundPainter,
    Size size = Size.zero,
    bool isComplex = false,
    bool willChange = false,
    Widget? child,
  }) : super(
            key: key,
            painter: painter,
            foregroundPainter: foregroundPainter,
            size: size,
            isComplex: isComplex,
            willChange: willChange,
            child: child);

  @override
  TrackRenderCustomPaint createRenderObject(BuildContext context) {
    return TrackRenderCustomPaint(
      painter: painter,
      foregroundPainter: foregroundPainter,
      preferredSize: size,
      isComplex: isComplex,
      willChange: willChange,
    );
  }
}

class TrackRenderCustomPaint extends RenderCustomPaint {
  TrackRenderCustomPaint({
    CustomPainter? painter,
    CustomPainter? foregroundPainter,
    Size preferredSize = Size.zero,
    bool isComplex = false,
    bool willChange = false,
    RenderBox? child,
  }) : super(
          painter: painter,
          foregroundPainter: foregroundPainter,
          preferredSize: preferredSize,
          isComplex: isComplex,
          willChange: willChange,
          child: child,
        );

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    VideoTrackPainter trackPainter = painter as VideoTrackPainter;
    return trackPainter.interceptTouchEvent(position);
  }
}
