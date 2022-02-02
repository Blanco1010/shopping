import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shop_app/api/environment.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/order.dart';
import '../../models/user.dart';
import '../../widgets/snackbar.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class DeliveryMapController {
  late BuildContext context;
  late Function refresh;

  Position? _position;
  StreamSubscription? _positionStream;

  String? addressName;
  LatLng? addressLatLng;

  bool isFollow = false;

  CameraPosition initialPosition = const CameraPosition(
    target: LatLng(4.801833, -75.739738),
    zoom: 16,
  );

  final Completer<GoogleMapController> _mapController = Completer();

  late BitmapDescriptor deliveryMarker;
  late BitmapDescriptor toMarker;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Order? order;

  final OrderProvider _orderProvider = OrderProvider();
  User? user;

  late IO.Socket socket;

  Future init(BuildContext context, Function refresh, Order? order) async {
    this.refresh = refresh;
    this.context = context;
    this.order = order;

    //SOCKET TO GET LOCATION OF DELIVERYMEN.
    socket = IO.io(
      'http://${Environment.apiDilevery}/orders/delivery',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );
    socket.connect();

    user = User.fromJson(await SecureStogare().read('user'));

    _orderProvider.init(context, user!.sessionToken, user!.id!);

    deliveryMarker =
        await createMarkerFromAssets('assets/img/icon_location.png');

    toMarker = await createMarkerFromAssets('assets/img/icon_home.png');

    checkGPS();
  }

  void emitPosition() {
    socket.emit('position', {
      'id_order': order!.id,
      'lat': _position!.latitude,
      'lng': _position!.longitude,
    });
  }

  distanceBetweenStartToEnd() {
    final double _distanceBetween = Geolocator.distanceBetween(
      _position!.latitude,
      _position!.longitude,
      order!.address!.lat,
      order!.address!.lng,
    );

    return _distanceBetween;
  }

  void launchWaze() async {
    var url =
        'waze://?ll=${order!.address!.lat.toString()},${order!.address!.lng.toString()}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${order!.address!.lat.toString()},${order!.address!.lng.toString()}&navigate=yes';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void launchGoogleMaps() async {
    var url =
        'google.navigation:q=${order!.address!.lat.toString()},${order!.address!.lng.toString()}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${order!.address!.lat.toString()},${order!.address!.lng.toString()}';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void updateToDelivered() async {
    if (distanceBetweenStartToEnd() <= 200) {
      ResponseApi responseapi = await _orderProvider.updateToDelivered(order!);

      if (responseapi.success) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/delivery/orders/list',
          (route) => false,
        );
      }
    } else {
      Snackbar.show(context, 'Debes estar mas cerca a la posición de entrega');
    }
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

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor descriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void dispose() {
    _positionStream?.cancel();
    socket.disconnect();
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

      _positionStream = Geolocator.getPositionStream().listen((Position pos) {
        _position = pos;

        emitPosition();

        addMarker(
          'delivery',
          pos.latitude,
          pos.longitude,
          '',
          '',
          deliveryMarker,
        );

        animateCameraToPosition(_position!.latitude, _position!.longitude);

        refresh();
      });
    } catch (error) {
      print(error);
    }
  }

  void call() {
    launch("tel:${order?.client?.phone}");
  }

  Future animateCameraToPosition(double lat, double lng) async {
    if (!isFollow) {
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
