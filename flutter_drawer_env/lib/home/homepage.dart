import 'package:flutter/material.dart';

import '../base/networking.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
            onPressed: (){
              HttpQuerery.download(
                  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585308257403&di=6e2a5a4a11e9ffdb9fef72a776f54605&imgtype=0&src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F1110%2Fcd71e43a3076f36284057528380e3dea.jpg',
                  '/Users/lishihang/Desktop/a.jpg',
              );
            },
            child: Text('下载'),
        ),
      ),
    );
  }
}
