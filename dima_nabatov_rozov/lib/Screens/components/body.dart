import 'package:dima_nabatov_rozov/Screens/Login_Google/login_google.dart';
import 'package:dima_nabatov_rozov/Screens/components/background.dart';
import 'package:dima_nabatov_rozov/Screens/components/rounded_button.dart';
import 'package:dima_nabatov_rozov/busLogic/FIT%20API/auth.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';


class BodyLogin extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyLogin> {

  bool _initialized = false;
  bool _error = false;

  /*void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }

  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }*/

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
                text: "Sign In With Google Fit",
                press: () { 
                  if (_initialized == false) {
                    AuthService auth = new AuthService();

                    auth.googleSignIn().then((result) {
                    if (result != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return GoogleLogin();
                          },
                        ),
                      );
                    }
                   });
                  }
                },
                image: Image(image: AssetImage("assets/icons/google-logo.png"), height: 25.0),
              ),  
              RoundedButton(
                text: "Sign In With HealthKit",
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
                image: Image(image: AssetImage("assets/icons/google-logo.png"), height: 25.0),
              )
          ],),
      ),
    );
  }
}
