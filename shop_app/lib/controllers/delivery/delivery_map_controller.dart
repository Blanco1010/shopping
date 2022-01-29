import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/order.dart';

class DeliveryMapController {
  late BuildContext context;
  late Function refresh;

  Position? _position;

  String? addressName;
  LatLng? addressLatLng;

  CameraPosition initialPosition = const CameraPosition(
    target: LatLng(4.801833, -75.739738),
    zoom: 16,
  );

  final Completer<GoogleMapController> _mapController = Completer();

  late BitmapDescriptor deliveryMarker;
  late BitmapDescriptor toMarker;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Order? order;

  Future init(BuildContext context, Function refresh, Order? order) async {
    this.refresh = refresh;
    this.context = context;
    this.order = order;

    deliveryMarker =
        await createMarkerFromAssets('assets/img/icon_location.png');

    toMarker = await createMarkerFromAssets('assets/img/icon_home.png');

    checkGPS();
  }

  void addMarker(
    String markerId,
    double lat,
    double lng,
    String title,
    String content,
    BitmapDescriptor iconMarker,
  ) {
    MarkerId id = MarkerId(markerId);

    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
    );

    markers[id] = marker;

    refresh();
  }

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng?.latitude,
      'lng': addressLatLng?.longitude,
    };
    Navigator.pop(context, data);
  }

  // Future<void> setLocationDraggableInfo() async {
  //   double lat = initialPosition.target.latitude;
  //   double lng = initialPosition.target.longitude;

  //   List<Placemark> address = await placemarkFromCoordinates(lat, lng);

  //   String? direction = address[0].thoroughfare;
  //   String? street = address[0].subThoroughfare;
  //   String? city = address[0].locality;
  //   String? department = address[0].administrativeArea;
  //   // String? country = address[0].country;

  //   addressName = '$direction # $street, $city, $department';
  //   addressLatLng = LatLng(lat, lng);

  //   refresh();
  // }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor descriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled) {
      updateLocation();
    }

    if (!isLocationEnabled) {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      animateCameraToPosition(_position!.latitude, _position!.longitude);
      addMarker(
        'delivery',
        _position!.latitude,
        _position!.longitude,
        'position',
        '',
        deliveryMarker,
      );

      addMarker(
        'home',
        order!.address!.lat,
        order!.address!.lng,
        'lugar de entrega',
        '',
        toMarker,
      );
    } catch (error) {
      print(error);
    }
  }

  Future animateCameraToPosition(double lat, double lng) async {
    GoogleMapController controller = await _mapController.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 16,
          bearing: 0,
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
