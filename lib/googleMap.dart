import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class _googleMapPage extends MaterialPageRoute<bool> {

  _googleMapPage() : super(builder: (BuildContext context) {
    LatLng _initialPosition = LatLng(24.8765588, 121.1091453);
    GoogleMapController _controller;
    Location _location = Location();

      void _onMapCreated(GoogleMapController _cntrl) {
        _controller = _cntrl;
/*        _location.onLocationChanged.listen((l) { 
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
            ),
          );
        });*/
      }

      return Scaffold(
        appBar: AppBar(title: Text('Pick the course location'), elevation: 1.0),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialPosition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            )
          ])
        )
      );
    });
}
