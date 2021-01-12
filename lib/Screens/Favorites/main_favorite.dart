import 'package:flutter/material.dart';

import 'ListOfRoutes.dart';

class MainFavorite extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1.2,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: PathList(),
      )
    );
  }

}