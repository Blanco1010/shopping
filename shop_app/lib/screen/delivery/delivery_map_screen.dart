import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shop_app/controllers/delivery/delivery_map_controller.dart';
import '../../Theme/theme.dart';
import '../../models/order.dart';

class DeliveryMapScreen extends StatefulWidget {
  const DeliveryMapScreen({Key? key, required this.order}) : super(key: key);

  final Order? order;

  @override
  _DeliveryMapScreenState createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  final DeliveryMapController _con = DeliveryMapController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(
        context,
        refresh,
        widget.order,
      );
    });
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
          Positioned(
            child: SafeArea(
              child: GestureDetector(
                onTap: _con.launchGoogleMaps,
                child: _iconGoogleMaps(),
              ),
            ),
            top: 10,
            left: 10,
          ),
          Positioned(
            child: SafeArea(
              child: GestureDetector(
                onTap: _con.launchWaze,
                child: _iconWaze(),
              ),
            ),
            top: 60,
            left: 10,
          )
        ],
      ),
    );
  }

  Widget _buttonAccept() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyColors.colorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: () => _con.updateToDelivered(),
        child: const Text(
          'ENTREGAR PRODUCTO',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          Flexible(child:_listTileAddress(
            _con.order?.address?.neightborhood,
            'Barrio',
            Icons.my_location,
            )
          ),
          Flexible(child:_listTileAddress(
            _con.order?.address?.address,
            'Dirección',
            Icons.location_on,
            ),
          ),

          Divider(color: Colors.grey[400]),
          Flexible(child:_clintInfo()),
          Flexible(child: _buttonAccept(),
          )

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
              image: _con.order?.client?.image != null
                  ? NetworkImage(_con.order!.client!.image!) as ImageProvider
                  : const AssetImage('assets/img/no-image.png'),
              placeholder: const AssetImage('assets/gif/jar-loading.gif'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              '${_con.order?.client?.name ?? ''} ${_con.order?.client?.lastname ?? ''}',
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

  Widget _iconGoogleMaps() {
    return SizedBox(
      child: Image.asset('assets/img/google_maps.png'),
      height: 40,
      width: 40,
    );
  }

  Widget _iconWaze() {
    return SizedBox(
      child: Image.asset('assets/img/waze.png'),
      height: 40,
      width: 40,
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
