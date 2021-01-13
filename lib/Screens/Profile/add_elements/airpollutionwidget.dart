import 'package:cleanair_layout/BusinessLogic/locationPollution/colorpollution.dart';
import 'package:flutter/material.dart';

class AirPollutionWidget extends StatefulWidget {

  AirPollutionWidget({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;
  final List<dynamic> category = [Colors.green[400], 
                                  Colors.yellow[700],
                                  Colors.amber, 
                                  Colors.deepOrange, 
                                  Colors.red, 
                                  Colors.purple[900]];

  final List<dynamic> icons = [Icons.eco,
                               Icons.notification_important,
                               Icons.warning,
                              ];

  final List<String> text = [ "Excelent air!",
                              "Well, still okay",
                              "It's lightly polluted :(",
                              "It's not good I think",
                              "Dude, it's time to leave it!",
                              "Run to the shelter!"
                            ];

  @override
  _AirPollutionWidget createState() => _AirPollutionWidget();
}

class _AirPollutionWidget extends State<AirPollutionWidget> {
  

  @override
  Widget build(BuildContext context) {
    final APIWork ap = new APIWork();

    Stream <int> getColor() async* {
      yield* Stream.periodic(Duration(seconds: 10), (_) {
        return ap.returnColor();
      }).asyncMap((event) async => event);
    }

    Stream<Map<String, dynamic>> getMeasure() async* {
      yield* Stream.periodic(Duration(seconds: 10), (_) {
        return ap.getMeasures();
      }).asyncMap((event) async => event);
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
          Container(
            width: widget.size.width * 0.79,
            height: widget.size.height * 0.22,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: StreamBuilder<int>(
              stream: getColor(),
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: new BoxDecoration(
                      color: widget.category[snapshot.data],
                      borderRadius: new BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                  child: Icon(widget.icons[snapshot.data ~/ 2])
                                ),
                              ),
                            ],),
                            Column(children: [
                              Text(
                                widget.text[snapshot.data],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              )
                            ],)                           
                          ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StreamBuilder<Map<String, dynamic>>(
                              stream: getMeasure(),
                              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    height: widget.size.height * 0.12,
                                    width: widget.size.width * 0.77,
                                    child: GridView.count(
                                      crossAxisCount: 4,
                                      childAspectRatio: 2,
                                      children: [
                                        ParameterPollution(
                                          snapshot: snapshot.data['co'],
                                          data: 'co', 
                                          padding: 5.0,
                                          color: Colors.white,
                                        ),
                                        ParameterPollution(
                                          snapshot: snapshot.data['no'],
                                          data: 'no', 
                                          padding: 5.0,
                                          color: Colors.white,
                                        ),
                                        ParameterPollution(
                                          snapshot: snapshot.data['no2'],
                                          data: 'no2', 
                                          padding: 5.0,
                                          color: Colors.white,
                                        ),
                                        ParameterPollution(
                                          snapshot: snapshot.data['o3'],
                                          data: 'o3', 
                                          padding: 5.0,
                                          color: Colors.white,
                                        ),                                      
                                        ParameterPollution(
                                          snapshot: snapshot.data['so2'],
                                          data: 'so2', 
                                          padding: 5.0,
                                          color: Colors.white,
                                        ),
                                        ParameterPollution(
                                          snapshot: snapshot.data['pm2_5'],
                                          data: 'pm2.5', 
                                          padding: 5.0,
                                          color: Colors.white,
                                        ),
                                        ParameterPollution(
                                          snapshot: snapshot.data['pm10'],
                                          data: 'pm10', 
                                          padding: 5.0,
                                          color: Colors.white,
                                        ),
                                        ParameterPollution(
                                          snapshot: snapshot.data['nh3'],
                                          data: 'nh3', 
                                          padding: 5.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 80),
                                      child: Text(
                                        'The data will be soon!\nWait a few seconds', 
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                    ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 140),
                                      child: CircularProgressIndicator(),
                                    )
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('snapshot.hasError');
                } 
                else {
                  return Container(
                    child: CircularProgressIndicator(),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(40.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ]
                      ),
                   ); 
                }
              },
            ),
          )
      ]
    );
  }
}

class ParameterPollution extends StatelessWidget {
  const ParameterPollution({
    Key key,
    @required this.snapshot,
    @required this.data,
    @required this.padding,
    @required this.color,
  }) : super(key: key);

  final dynamic snapshot; 
  final String data;
  final dynamic padding;
  final dynamic color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Text('$data\n$snapshot', 
                      style: TextStyle(color: color), 
                      textScaleFactor: 0.9, 
                      textAlign: TextAlign.center,
            ),
    ],)
    );
  }
}
