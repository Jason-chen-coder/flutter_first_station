import 'dart:math';

import 'package:flutter/material.dart';

class DynamicBoxPage extends StatelessWidget {
  const DynamicBoxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey,
          body: Center(
            child: DynamicBox(
              width: 200,
              height: 100,
              color: Colors.white,
            ),
          )),
    );
  }
}

class DynamicBox extends StatelessWidget {
  const DynamicBox({Key? key, this.width, this.height, this.color}) : super(key: key);

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return DynamicRectBox(
        width: min(width ?? double.infinity, constraints.maxWidth),
        height: min(height ?? double.infinity, constraints.maxHeight),
        color: color,
      );
    });
  }
}

class DynamicRectBox extends StatefulWidget {
  const DynamicRectBox({Key? key, required this.width, required this.height, this.color}) : super(key: key);

  final double width;
  final double height;

  final Color? color;

  @override
  State<DynamicRectBox> createState() => _DynamicRectBoxState();
}

class _DynamicRectBoxState extends State<DynamicRectBox> {
  bool _isHover = false;
  bool _isFocus = false;

  final FocusNode focusNode = FocusNode();

  Offset? _globalPos;

  Offset _localPos = Offset(0, 0);

  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Stack(
      children: [
        Positioned(
          left: _globalPos?.dx,
          top: _globalPos?.dy,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              focusNode.requestFocus();
            },
            onPanDown: (DragDownDetails details) {
              setState(() {
                _localPos = details.localPosition;
                _globalPos = details.globalPosition - _localPos;
              });
            },
            onPanUpdate: (DragUpdateDetails details) {
              if (_isFocus) {
                setState(() {
                  _globalPos = details.globalPosition - _localPos;
                });
              }
            },
            onPanEnd: (DragEndDetails details) {
              setState(() {
                _localPos = Offset(0, 0);
              });
            },
            child: Focus(
              focusNode: focusNode,
              onFocusChange: (focus) {
                setState(() {
                  _isFocus = focus;
                });
              },
              child: MouseRegion(
                onEnter: (event) {
                  if (!_isFocus) {
                    setState(() {
                      _isHover = true;
                    });
                  }
                },
                onExit: (event) {
                  setState(() {
                    _isHover = false;
                  });
                },
                onHover: (event) {
                  if (_isFocus) {
                    //根据所在位置坐标，按住后执行不同的操作（水平、垂直、斜拉伸）
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: widget.color,
                        border: (_isFocus || _isHover)
                            ? Border.all(
                          color: themeData.primaryColor,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )
                            : null,
                      ),
                    ),
                    if (_isFocus) ...[
                      Positioned.fill(
                        top: -4,
                        left: -4,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: RectBoxCorner(),
                        ),
                      ),
                      Positioned.fill(
                        top: -4,
                        right: -4,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: RectBoxCorner(),
                        ),
                      ),
                      Positioned.fill(
                        left: -4,
                        bottom: -4,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: RectBoxCorner(),
                        ),
                      ),
                      Positioned.fill(
                        right: -4,
                        bottom: -4,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: RectBoxCorner(),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RectBoxCorner extends StatelessWidget {
  const RectBoxCorner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return MouseRegion(
      //没有旋转的符号
      // cursor: SystemMouseCursors.rotate,
      child: GestureDetector(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: themeData.primaryColor,
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
        ),
      ),
    );
  }
}
