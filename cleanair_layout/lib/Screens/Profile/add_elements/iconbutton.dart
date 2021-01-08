import 'package:flutter/material.dart';

class IconButtonContainer extends StatefulWidget {
    final Icon iconObject;
    final Function press;
    final String text;
    final double size;

    IconButtonContainer({
      Key key,
      @required this.iconObject,
      @required this.press,
      @required this.text,
      @required this.size,
    }) : super(key: key);

    @override
    _IconButtonState createState() => new _IconButtonState();
}

class _IconButtonState extends State<IconButtonContainer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      child: OutlineButton(
        padding: EdgeInsets.all(20.0),
        color: Colors.white10,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), 
        ),
        highlightColor: Colors.grey[300],
        highlightedBorderColor: Colors.white10,
        borderSide: BorderSide(color: Colors.white10, width: 0),
        onPressed: widget.press,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          widget.iconObject, 
          Text(
           widget.text, 
           style: TextStyle()
          )

          ],
        ),
      )
    );
  }

}