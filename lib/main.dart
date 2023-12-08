import 'package:flutter/material.dart';
// import 'counter/counter_page.dart';
// import 'guess/guess_page.dart';
import 'drag_rect/CustomPainterDraggable.dart';
import 'drag_rect/DynamicBoxPage.dart';
import 'drag_rect/SectorPainter.dart';
import 'muyu/muyu_page.dart';
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
      // home:const CustomPainterDraggable()
        home:  const SectorPainter(),

    );
  }
}
