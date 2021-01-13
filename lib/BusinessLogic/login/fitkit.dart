import 'package:flutter/material.dart';
import 'dart:async';
import 'package:health/health.dart';

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class FitInfo extends StatefulWidget {

  @override
  _FitInfoState createState() => _FitInfoState();

}

class _FitInfoState extends State<FitInfo> {

  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    // Get everything from midnigt until now
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(2021, 01, 01);

    HealthFactory health = HealthFactory();

    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.HEIGHT,
    ];

    setState( () => _state = AppState.FETCHING_DATA);

    // We must request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);
    if(accessWasGranted) {
      try {
        // Fetch new data
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);

        // Save it
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      // filter duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // Print the results
      _healthDataList.forEach((x) { print("Data point: $x"); });

      // set the UI
      setState( () {
        _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print('Authorization not granted');
      setState(() {
        _state = AppState.DATA_NOT_FETCHED;
      });
    }
  }

  Widget _contentDataReady() {
    return ListView.builder(
      itemCount: _healthDataList.length,
      itemBuilder: (_, index) {
        HealthDataPoint p = _healthDataList[index];
        return ListTile(
          title: Text("${p.typeString}: ${p.value}"),
          trailing: Text("${p.unitString}"),
          subtitle: Text("${p.dateFrom} - ${p.dateTo}"),
          leading: Icon(Icons.sports),
          dense: true,
        );
      },
    );
  }

  Widget _contentNoData() {
    return Text("There is no data :(", textAlign: TextAlign.center,);
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(
            strokeWidth: 10,
          ),
        ),
        Text("Fetching data..."),
      ],
    );
  }

  Widget _authorizationNotGranted() {
    return Text("Authorization not given");
  }

  Widget _contentNotFetched() {
    return Text("Press the Download button to get data");
  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();
    
    return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fit', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          elevation: 1.2,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.file_download), 
              onPressed: () {
                fetchData();
              }
            )
          ]
      ),
      body: Center(
        child: _content(),
      ),
    );
  }

}