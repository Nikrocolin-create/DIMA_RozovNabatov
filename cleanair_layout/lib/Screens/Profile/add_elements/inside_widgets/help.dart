import 'package:flutter/material.dart';

import '../../../../constants.dart';

class HelpIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundHelp(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              "If there is any problem\nPlease, contact the developers!",
              style: TextStyle(
                fontSize: 22.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0,),
            Text(
              "9nik812@gmail.com\nserynabatov@gmail.com",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.0
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundHelp extends StatelessWidget {

  final Widget child;
  const BackgroundHelp({
    Key key,
    @required this.child
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                width: size.width * 0.5,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                width: size.width * 0.4,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

}
