import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';

import '../../controllers/delivery/delivery_orders_list_controller.dart';

class DeliveryOrdersListScreen extends StatefulWidget {
  const DeliveryOrdersListScreen({Key? key}) : super(key: key);

  @override
  _DeliveryOrdersListScreenState createState() =>
      _DeliveryOrdersListScreenState();
}

class _DeliveryOrdersListScreenState extends State<DeliveryOrdersListScreen> {
  final DeliveryOrdersListController _con = DeliveryOrdersListController();

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
      drawerEnableOpenDragGesture: false,
      key: _con.key,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => _con.openDrawer(),
          child: const Icon(Icons.menu),
        ),
      ),
      drawer: _drawer(),
      body: const Center(
        child: Text('Deliverys Orders'),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [MyColors.colorPrimary, MyColors.primaryOpactyColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage: _con.user?.image == null
                      ? const AssetImage('assets/img/no-image.png')
                      : NetworkImage(_con.user!.image) as ImageProvider,
                ),
                const SizedBox(height: 15),
                Text(
                  '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.email ?? '',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.phone ?? '',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          _con.user != null && _con.user!.roles!.length > 1
              ? ListTile(
                  title: const Text('Seleccionar rol'),
                  trailing: const Icon(Icons.person_outline),
                  onTap: _con.goToRoles,
                )
              : Container(),
          ListTile(
            onTap: _con.logout,
            title: const Text('Cerrar sesion'),
            trailing: const Icon(Icons.power_settings_new_outlined),
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}