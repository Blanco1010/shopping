import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/client/client_map_controller.dart';
import '../../models/order.dart';

class ClientMapScreen extends StatefulWidget {
  const ClientMapScreen({Key? key, required this.order}) : super(key: key);

  final Order? order;

  @override
  _ClientMapScreenState createState() => _ClientMapScreenState();
}

class _ClientMapScreenState extends State<ClientMapScreen> {
  final ClientMapController _con = ClientMapController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        _con.init(
          context,
          refresh,
          widget.order,
        );
      },
    );
  }

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: googleMaps(),
          ),
          SafeArea(
            child: Column(
              children: [
                _buttonCenterPosition(),
                const Spacer(),
                _cardInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _listTileAddress(
            _con.order?.address?.neightborhood,
            'Barrio',
            Icons.my_location,
          ),
          _listTileAddress(
            _con.order?.address?.address,
            'Dirección',
            Icons.location_on,
          ),
          Divider(color: Colors.grey[400]),
          const Spacer(),
          _clintInfo(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _clintInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            height: 60,
            width: 60,
            child: FadeInImage(
              fit: BoxFit.cover,
              image: _con.order?.delivery?.image != null
                  ? NetworkImage(_con.order!.delivery!.image!) as ImageProvider
                  : const AssetImage('assets/img/no-image.png'),
              placeholder: const AssetImage('assets/gif/jar-loading.gif'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              '${_con.order?.delivery!.name ?? ''} ${_con.order?.delivery!.lastname ?? ''}',
              style: const TextStyle(
                fontSize: 22,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              color: Colors.grey[300],
            ),
            child: IconButton(
              onPressed: () {
                _con.call();
              },
              icon: const Icon(
                Icons.phone,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listTileAddress(String? title, String subtitle, IconData iconData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        title: Text(
          title ?? '',
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(iconData),
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: () {
        _con.isFollow = !_con.isFollow;
        refresh();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10, top: 10),
        alignment: Alignment.topRight,
        child: Card(
          shape: const CircleBorder(),
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              !_con.isFollow ? Icons.follow_the_signs : Icons.map,
              color: Colors.grey[800],
              size: 30,
            ),
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
