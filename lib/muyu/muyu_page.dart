import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_first_station/muyu/count_panel.dart';

import 'animate_text.dart';
import 'muyu_image.dart';
import 'package:flame_audio/flame_audio.dart';

class MuyuPage extends StatefulWidget {
  const MuyuPage({Key? key}) : super(key: key);
  @override
  State<MuyuPage> createState() => _MuyuPageState();
}

class _MuyuPageState extends State<MuyuPage> {
  AudioPool? pool;
  int _counter = 0;
  final Random _random = Random();
  int _curVal = 0;
  @override
  void initState() {
    super.initState();
    _initAudioPool();
  }

  void _initAudioPool() async {
    pool = await FlameAudio.createPool(
      'muyu_1.mp3',
      maxPlayers: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('电子木鱼'),
        actions: [
          IconButton(onPressed: _toHistory, icon: const Icon(Icons.history))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: CountPanel(
            count: _counter,
            onTapSwitchAudio: _onTapSwitchAudio,
            onTapSwitchImage: _onTapSwitchImage,
          )),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                 MuyuAssetsImage(
                    image: 'assets/images/muyu.png', onTap: _onKnock),
                if(_curVal != 0)  AnimateText(text:"功德+$_curVal")
              ],
            ),
              )
        ],
      ),
    );
  }

  void _toHistory() {}
  void _onTapSwitchAudio() {}
  void _onTapSwitchImage() {}
  void _onKnock() {
    pool?.start();
    setState(() {
      _curVal  = 1 + _random.nextInt(3);
      _counter += _curVal;
    });
  }
}