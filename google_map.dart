import 'dart:collection';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class GMap extends StatefulWidget {
  GMap({Key key}): super(key:key);
  _GMapState createState()=> _GMapState();
}

class _GMapState extends State<GMap>{
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;



  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;

    setMarkerIcon() as

    setState(() {
      _markers.add(
          Marker(
            markerId: MarkerId('0'),
            position: LatLng(37.77483, -122.41942),
            infoWindow: InfoWindow(
              title: "San Francisco",
              snippet: "An interesting city",
            ),
          ));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(37.77483, -122.41942),
            zoom: 12,
          ),),
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
          child: Text('AtrolabeInc');
        )
      ],)
      );
  }
}

