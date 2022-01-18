import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/client/client_address_map_controller.dart';

class ClientAddressMapScreen extends StatefulWidget {
  const ClientAddressMapScreen({Key? key}) : super(key: key);

  @override
  _ClientAddressMapScreenState createState() => _ClientAddressMapScreenState();
}

class _ClientAddressMapScreenState extends State<ClientAddressMapScreen> {
  final ClientAddressMapController _con = ClientAddressMapController();

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
        appBar: AppBar(
          title: const Text('Ubica tu dirección en el mapa'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            googleMaps(),
            Positioned(
              child: FadeInUp(
                from: -MediaQuery.of(context).size.height,
                child: const Center(
                  child: Icon(
                    Icons.location_searching,
                    size: 50,
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }

  void refresh() {
    setState(() {});
  }
}
