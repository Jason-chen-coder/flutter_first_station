import 'package:flutter/material.dart';
// import 'counter/counter_page.dart';
// import 'guess/guess_page.dart';
import 'muyu/muyu_page.dart';
import 'video_crop_track/video_crop_track_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: const GuessPage(title:'猜数字'),
      home:const VideoCropTrackPage()
    );
  }
}
