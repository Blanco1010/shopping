import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shop_app/controllers/delivery/delivery_map_controller.dart';
import '../../Theme/theme.dart';

class DeliveryMapScreen extends StatefulWidget {
  const DeliveryMapScreen({Key? key}) : super(key: key);

  @override
  _DeliveryMapScreenState createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  final DeliveryMapController _con = DeliveryMapController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        googleMaps(),
        Container(
          alignment: Alignment.bottomCenter,
          child: _buttonAccept(),
        ),
      ],
    ));
  }

  Widget _buttonAccept() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyColors.colorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () {
          _con.selectRefPoint();
        },
        child: const Text(
          'SELECCIONAR ESTE PUNTO',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
    );
  }

  void refresh() {
    setState(() {});
  }
}
