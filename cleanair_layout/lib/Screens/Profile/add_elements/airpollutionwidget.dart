import 'package:flutter/material.dart';

class AirPollutionWidget extends StatelessWidget {
  
  const AirPollutionWidget({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
          Container(
            width: size.width * 0.79,
            height: size.height * 0.2,
            color: Colors.grey[300],
            margin: EdgeInsets.symmetric(vertical: 10),
            child: OutlineButton(
              
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onPressed: () {
              },
              child: Text(
                "Here will be the air pollution in your district",
              ),
            )
          )
      ]
    );
  }
}
