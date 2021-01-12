import 'package:cleanair_layout/Screens/Profile/add_elements/airpollutionwidget.dart';
import 'package:cleanair_layout/Screens/Profile/add_elements/iconcontainer.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1.2,
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column (
              children: <Widget>[
                SizedBox(height: size.height * 0.05,),
                IconContainerMenu(),
                SizedBox(height: size.height * 0.12,),
                AirPollutionWidget(size: size),
              ],
            ),
          )
         ) 
      ),
    );
  }

}