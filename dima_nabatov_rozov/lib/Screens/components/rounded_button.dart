import 'package:flutter/material.dart';
import 'package:dima_nabatov_rozov/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final Image image;

  const RoundedButton({
    Key key,
    this.text, 
    this.press, 
    this.image,
    //this.color = Colors.grey, 
    //this.textColor = Colors.grey
    this.color = kPrimaryColor,
    this.textColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: OutlineButton(
        splashColor: this.color,
        onPressed: this.press,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: this.color),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              this.image,
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  this.text,
                  style: TextStyle(
                    fontSize: 20,
                    color: this.textColor,
                ),
              ),
            )
          ],
        ),
      ),
      )
    );
  }
}

