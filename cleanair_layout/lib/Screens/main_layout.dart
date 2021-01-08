import 'package:cleanair_layout/Screens/Favorites/main_favorite.dart';
import 'package:cleanair_layout/constants.dart';
import 'package:flutter/material.dart';
import 'package:cleanair_layout/Screens/Map/map_main.dart';
import 'package:cleanair_layout/Screens/Profile/profile_main.dart';

class MainLayout extends StatefulWidget {
  //const MainLayout({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainLayoutState();
  }

}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final List<Widget> _children = <Widget>[
    MainMenu(),
    MainMap(),
    MainFavorite()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 15,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: kPrimaryColor,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.menu),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}