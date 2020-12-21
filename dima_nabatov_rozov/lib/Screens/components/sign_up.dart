import 'package:flutter/material.dart';

import '../../constants.dart';

class SignUp extends StatelessWidget {
  final bool login;
  final Function press;

  const SignUp({
    Key key, 
    this.login = true, 
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.login ? "Don't have an Account ? " : "Already have an Account ?", 
          style: TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: this.press,
          child: Text(
            this.login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }
}