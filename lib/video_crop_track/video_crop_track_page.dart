import 'package:flutter/material.dart';
import './video_track_widget.dart';

class VideoCropTrackPage extends StatefulWidget {
  const VideoCropTrackPage({Key? key}) : super(key: key);

  @override
  _VideoCropTrackPageState createState() => _VideoCropTrackPageState();
}

class _VideoCropTrackPageState extends State<VideoCropTrackPage> {
  int num = 0;

  final Duration duration = Duration(minutes: 1);
  List<String> list2 = [
    '图1',
    '图2',
    '图3',
    '图4',
    '图5',
    '图6',
    '图7',
    '图8',
    '图9',
    '图10',
    '图11',
    '图12',
    '图13',
    '图14',
    '图15',
    '图16',
  ];
  final Duration duration2 = Duration(minutes: 4);
  GlobalKey<VideoTrackWidgetState> key1 = GlobalKey();
  GlobalKey<VideoTrackWidgetState> key2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Duration totalDuration  = Duration(minutes: 1);
    List<String> list = [
      '图1',
      '图2',
      '图3',
      '图4',
      '图5',
      '图6',
      '图7',
      '图8',
      '图9',
    ];
    GlobalKey<VideoTrackWidgetState> key1 = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter视频裁剪编辑的轨道UI'),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Text('小于等于3分钟的视频展示num${num}'),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.blue,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                // 开头左侧留白(时间线是居中显示的)
                Container(
                  color: Colors.orange,
                  width:100,
                ),
                Container(
                  color: Colors.red,
                  width:900,
                  child:Column(
                    children: [
                      VideoTrackWidget(
                        key: key1,
                        imgList: list,
                        totalDuration: totalDuration,
                        onSelectDuration: (start, end) {
                          print('轨道1选择的时间段：$start ~ $end');
                        },
                        trackWidgetBuilder:
                            (BuildContext context, String data, Size size) {
                          return Container(
                            height: size.height,
                            width: size.width,
                            color: Colors.blueAccent,
                            child: Center(
                              child: Text(
                                data,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.orange,
                  width:100,
                ),
              ],),
          ),
          _timelineControl(key1),
          SizedBox(height: 50),
          Text('大于3分钟的视频展示'),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: VideoTrackWidget(
              key: key2,
              imgList: list2,
              totalDuration: duration2,
              onSelectDuration: (start, end) {
                print('轨道2选择的时间段：$start ~ $end');
              },
              trackWidgetBuilder:
                  (BuildContext context, String data, Size size) {
                return Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.blueAccent,
                  child: Center(
                    child: Text(
                      data,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          _timelineControl(key2),
        ],
      ),
    );
  }

  _timelineControl(GlobalKey<VideoTrackWidgetState> key) {
    return Column(
      children: [
        SizedBox(height: 10),
        Text('时间线控制'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              minWidth: 0,
              child: Text('开始'),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                key.currentState!.startTimelineAnimation();
              },
            ),
            SizedBox(width: 16),
            MaterialButton(
              minWidth: 0,
              child: Text('暂停'),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                key.currentState!.stopTimelineAnimation();
              },
            ),
            SizedBox(width: 16),
            MaterialButton(
              minWidth: 0,
              child: Text('继续'),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                key.currentState!.continueTimelineAnimation();
              },
            ),
            SizedBox(width: 16),
            MaterialButton(
              minWidth: 0,
              child: Text('重新开始'),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                key.currentState!.startTimelineAnimation(reset: true);
              },
            )
          ],
        ),
      ],
    );
  }
}
