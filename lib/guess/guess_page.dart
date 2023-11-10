import 'package:flutter/material.dart';
import 'dart:math';
import 'result_notice.dart';
import 'guess_app_bar.dart';
class GuessPage extends StatefulWidget {
  const GuessPage({super.key, required this.title});

  final String title;

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  int _value = 0;
  Random _random  = Random();
  bool _guessing = false;
  bool? _isBig ;
  void _generateRandomValue() {
    setState(() {
      _guessing = true;// 点击按钮时，表示游戏开始
      _value = _random.nextInt(100);
    });
  }

  //创建 _guessCtrl 属性，作为 GuessAppBar 构造入参，就可以和输入框进行绑定。当输入文字，点击按钮后，查看控制台，就可以看到输入信息。
  final TextEditingController _guessCtrl = TextEditingController();

  void _onCheck(){
    print("=======Check:目标数值:$_value===猜的数值:${_guessCtrl.text}=====");
    int? guessValue = int.tryParse(_guessCtrl.text);
    if(!_guessing || guessValue == null) return;

    //猜对了
    if(guessValue == _value){
      setState(() {
        _isBig = null;
        _guessing = false;
      });
      return;
    }

    //猜错了
    setState(() {
      _isBig = guessValue > _value ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GuessAppBar(onCheck: _onCheck,controller: _guessCtrl),
      body:Stack(
        children: [
          if(_isBig != null)
            Column(
            children: [
              if(_isBig!)
              const ResultNotice(color:Colors.redAccent,info:'大了'),
              Spacer(),
              if(!_isBig!)
              const ResultNotice(color:Colors.blueAccent,info:'小了'),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if(!_guessing)
                  const Text('点击生成随机数值'),
                Text(
                  _guessing?'**':'$_value',
                  style: TextStyle(
                    fontSize: 68,fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _guessing? null :_generateRandomValue,
        backgroundColor: _guessing ? Colors.grey : Colors.blue,
        tooltip: 'Increment',
        child: const Icon(Icons.generating_tokens_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
}
}

