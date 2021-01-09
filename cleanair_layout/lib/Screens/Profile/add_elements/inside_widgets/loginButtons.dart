import 'package:flutter/material.dart';

class LogInButtons extends StatelessWidget {
  const LogInButtons({
    Key key,
    @required this.size,
    @required this.text,
    @required this.image,
    @required this.onPress,
  }) : super(key: key);

  final Size size;
  final String text;
  final Image image;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.6,
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        highlightElevation: 0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              this.image,
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(this.text)
              )
            ],
          ),
        ),
        onPressed: this.onPress,
      ),
    );
  }
}

