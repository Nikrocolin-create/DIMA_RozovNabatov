import 'package:flutter/material.dart';
import 'loginButtons.dart';

class CustomDialogLogin extends StatelessWidget {

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
                    onPress: () {},
                  ),
                  LogInButtons(
                    size: size,
                    text: "Sign In With HealthKit",
                    image: Image(image: AssetImage("assets/icons/health-logo.png"), height: 18.0,),
                    onPress: () {},
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

