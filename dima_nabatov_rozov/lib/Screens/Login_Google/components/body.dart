import 'dart:async';

import 'package:dima_nabatov_rozov/Screens/Login_Google/components/background.dart';
import 'package:dima_nabatov_rozov/Screens/components/rounded_button.dart';
import 'package:dima_nabatov_rozov/Screens/components/rounded_input_field.dart';
import 'package:dima_nabatov_rozov/Screens/components/rounded_password_field.dart';
import 'package:dima_nabatov_rozov/Screens/components/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            "assets/icons/google-icon.svg",
            height: size.height * 0.2,
            width: size.width * 0.3,
          ),
          SizedBox(
            height: size.height * 0.03
          ),
          RoundedInputField(
            hintText: "Your email",
            onChanged: (value) {

            }, 
          ),
          RoundedPasswordField(
            onChanged: (value) {

            },
          ),
          RoundedButton(
            text: "LOGIN",
            press: () {
            },
            image: Image(image: AssetImage("assets/icons/google-logo.png"), height: 25.0),
          ),
          SignUp(
            press: () {},
          )
        ],
      ),
    );
  }
}


void read() async {
  try {
    final results = await FitKit.read(
      DataType.HEART_RATE,
      //dateFrom: DateTime.now().subtract(Duration(days: 5)),
      //dateTo: DateTime.now(),
    );
    print(results);
  } on UnsupportedException catch (e) {
    // thrown in case e.dataType is unsupported
  }
}

  Future<void> hasPermissions() async {
    bool permissions;
    String result ='';
    try {
      permissions = await FitKit.hasPermissions(DataType.values);
      print(permissions);
    } catch (e) {
      result = 'hasPermissions: $e';
    }

    //if (!mounted) return;

  }



/*
class GoogleFitInstance extends StatefulWidget {

  @override
  _GoogleFitInstance createState() => _GoogleFitInstance();

}

class _GoogleFitInstance extends State<GoogleFitInstance> {
  String result = '';
  Map<DataType, List<FitData>> results = Map();
  bool permissions;

  RangeValues _dateRange = RangeValues(1, 8);
  List<DateTime> _dates = List<DateTime>();
  double _limitRange = 0;

  DateTime get _dateFrom => _dates[_dateRange.start.round()];
  DateTime get _dateTo => _dates[_dateRange.end.round()];
  int get _limit => _limitRange == 0.0 ? null : _limitRange.round();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _dates.add(null);
    for (int i = 7; i >= 0; i --) {
      _dates.add(DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i)));
    }
    _dates.add(null);

    hasPermissions();
  }

  Future<void> hasPermissions() async {
    try {
      permissions = await FitKit.hasPermissions(DataType.values);
    } catch (e) {
      result = 'hasPermissions: $e';
    }

    if (!mounted) return;

    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [Text('D')],),
      ),
    );
  }

} */