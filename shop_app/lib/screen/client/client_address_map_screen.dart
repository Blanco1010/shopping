import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Theme/theme.dart';
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
            _iconMyLocation(),
            _cardPositionName(),
            Container(
              alignment: Alignment.bottomCenter,
              child: _buttonAccept(),
            ),
          ],
        ));
  }

  Widget _cardPositionName() {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 20),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        color: Colors.grey[800],
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            _con.addressName ?? '',
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
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

  FadeInUp _iconMyLocation() {
    return FadeInUp(
      from: -MediaQuery.of(context).size.height,
      child: Container(
        alignment: Alignment.center,
        child: const Icon(
          Icons.location_searching,
          size: 50,
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
      onCameraMove: (pos) => _con.initialPosition = pos,
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  void refresh() {
    setState(() {});
  }
}
