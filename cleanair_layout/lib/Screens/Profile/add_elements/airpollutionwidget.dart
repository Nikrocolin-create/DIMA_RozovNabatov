import 'package:cleanair_layout/BusinessLogic/locationPollution/colorpollution.dart';
import 'package:flutter/material.dart';

class AirPollutionWidget extends StatefulWidget {

  AirPollutionWidget({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;
  final List<dynamic> category = [Colors.green[400], 
                                  Colors.yellow,
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
                              "Dude, it's time to leave it!"
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
            height: widget.size.height * 0.17,
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
                          children: [
                            //SizedBox(width: 0.09 * widget.size.width,),
                            StreamBuilder<Map<String, dynamic>>(
                              stream: getMeasure(),
                              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ParameterPollution(
                                        snapshot: snapshot.data['co'],
                                        data: 'co', 
                                      ),
                                      ParameterPollution(
                                        snapshot: snapshot.data['no'],
                                        data: 'no', 
                                      ),
                                      ParameterPollution(
                                        snapshot: snapshot.data['no2'],
                                        data: 'no2', 
                                      ),
                                      ParameterPollution(
                                        snapshot: snapshot.data['o3'],
                                        data: 'o3', 
                                      ),                                      
                                      ParameterPollution(
                                        snapshot: snapshot.data['so2'],
                                        data: 'so2', 
                                      ),
                                      ParameterPollution(
                                        snapshot: snapshot.data['pm2_5'],
                                        data: 'pm2.5', 
                                      ),
                                      ParameterPollution(
                                        snapshot: snapshot.data['pm10'],
                                        data: 'pm10', 
                                      ),
                                      ParameterPollution(
                                        snapshot: snapshot.data['nh3'],
                                        data: 'nh3', 
                                      ),                                                                         
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('The data will be soon!\nWait a few seconds');
                                } else {
                                  return CircularProgressIndicator();
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
  }) : super(key: key);

  final double snapshot; 
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(children: [
        Text('$data', style: TextStyle(color: Colors.white),),
        Text('$snapshot', style: TextStyle(color: Colors.white),),
    ],)
    );
  }
}
