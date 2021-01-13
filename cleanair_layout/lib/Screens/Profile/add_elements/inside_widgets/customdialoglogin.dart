import 'package:cleanair_layout/BusinessLogic/login/auth.dart';
import 'package:cleanair_layout/BusinessLogic/login/fitkit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'loginButtons.dart';

class CustomDialogLogin extends StatefulWidget {

  @override
  _CustomDialogLoginState createState() => _CustomDialogLoginState(); 

}

class _CustomDialogLoginState extends State<CustomDialogLogin> {

  bool _initialized = false;
  bool _error = false; 

  void initializeFlutterFire() async {
    // await Firebase.initializeApp();
    setState(() {
      _initialized = true;
    });
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment(0, 1),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 5,
              child: Column(
                children: <Widget>[
                  LogInButtons(
                    size: size, 
                    text: "Sign In With Google Fit",
                    image: Image(image: AssetImage("assets/icons/google-logo.png"), height: 15.0,),
                    onPress: () {
                      //if (_initialized == true) {
                      //  AuthGoogleService auth = new AuthGoogleService();

                      //  auth.googleSignIn().then((result) {
                      //    if (result != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return FitInfo();
                                }
                              ),
                            );
                          //}
                       // });
                      //}
                    },
                  ),
                  LogInButtons(
                    size: size,
                    text: "Sign In With HealthKit",
                    image: Image(image: AssetImage("assets/icons/health-logo.png"), height: 18.0,),
                    onPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return FitInfo();
                          }
                        ),
                      );                      
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
    
  }
}

