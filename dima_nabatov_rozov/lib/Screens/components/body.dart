import 'package:dima_nabatov_rozov/Screens/Login_Google/login_google.dart';
import 'package:dima_nabatov_rozov/Screens/components/background.dart';
import 'package:dima_nabatov_rozov/Screens/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BodyLogin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // This size provide us total height and 
    // width of our screen
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //SvgPicture.asset("assets/icons/cach.svg")
            Image.asset(
              "assets/icons/cach.png",
              height: size.height * 0.4,
              width: size.width ),
              RoundedButton(
                text: "GOOGLE FIT",
                press: () { 
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) {
                        return GoogleLogin();
                      }
                    ),
                  );
                },
              ),
              RoundedButton(
                text: "HEALTH KIT",
                press: () { }
              )
          ],),
      ),
    );
  }
}
