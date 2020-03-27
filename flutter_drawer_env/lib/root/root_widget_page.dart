import 'package:flutter/material.dart';
import 'package:flutterdrawerenv/home/homepage.dart';
import 'package:flutterdrawerenv/mine/minepage.dart';

class RootWidgetPage extends StatefulWidget {
  @override
  _RootWidgetPageState createState() => _RootWidgetPageState();
}

class _RootWidgetPageState extends State<RootWidgetPage> {
  List titles = ['首页', '我的'];
  List nativeTitles = ['首页', '我的'];
  int _currentIndex = 0;

  List<IconData> normalLeftIcons = [
    Icons.home,
    Icons.person,
  ];
  var _body;

  void initData() {
    _body = IndexedStack(
      children: <Widget>[HomePage(), MinePage()],
      index: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
          appBar: AppBar(
            title: Text(nativeTitles[_currentIndex]),
          ),
          body: _body,
          drawer: Builder(builder: (BuildContext context) {
            return Drawer(
              child: Container(
                padding: EdgeInsets.zero,
                child: ListView(
                  children: _items(context),
                ),
              ),
            );
          })),
      routes: <String, WidgetBuilder>{
        // 路由表注册
      },
    );
  }

  Widget _drawerHeader(String title) {
    return DrawerHeader(
      child: Center(
        child: FlutterLogo(size: 100.0),
      ),
      decoration: BoxDecoration(color: Colors.white),
    );
  }

  List<Widget> _items(BuildContext context) {
    List<Widget> items = [_drawerHeader('Flutter')];
    for (int i = 0; i < titles.length; i++) {
      items.add(_item(context, normalLeftIcons[i], titles[i], nativeTitles[i]));
      items.add(Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Divider(
          color: Colors.grey,
        ),
      ));
    }
    return items;
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    String routeName,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            _currentIndex == titles.indexOf(title) ? Colors.blue : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            color: _currentIndex == titles.indexOf(title)
                ? Colors.blue
                : Colors.grey),
      ),
      onTap: () {
        setState(() {
          _currentIndex = titles.indexOf(title);
        });
        Navigator.pop(context);
      },
    );
  }
}
