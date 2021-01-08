// import 'package:cleanair_layout/constants.dart';
// import 'package:flutter/material.dart';

// class ButtonControlMenu extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return Row (
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           width: size.width * 0.4,
//           child: TextButton(
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
//             ),
//             autofocus: false,
//             onPressed: () {},
//             child: Text("Sign In", style: TextStyle(color: Colors.white),),
//           )
//         )
//       ],
//     );
//   }
// }

// class ButtonLogin extends StatelessWidget {

//   //final Image image;
//   final Size size;
//   final String text;
//   final Function press; 

//   const ButtonLogin({
//     Key key,
//     @required this.size,
//     @required this.press,
//     //@required this.image,
//     @required this.text,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container (
//       width: size.width * 0.35,
//       height: size.height * 0.1,
//       child: OutlineButton(
//         splashColor: Colors.grey[350],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         borderSide: BorderSide(color: kPrimaryColor),
//         onPressed: this.press,
//         child: Padding(
//           padding: EdgeInsets.only(left: 1),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               //this.image,
//               Padding(
//                 padding: const EdgeInsets.only(left: 1),
//                 child: Text(
//                   this.text,
//                   style: TextStyle(
//                     fontSize: 12,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),

//     );
//   }
// }
