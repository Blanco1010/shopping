import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/restaurant/restaurant_orders_list_controller.dart';

class RestaurantOrdersListScreen extends StatefulWidget {
  const RestaurantOrdersListScreen({Key? key}) : super(key: key);

  @override
  _RestaurantOrdersListScreenState createState() =>
      _RestaurantOrdersListScreenState();
}

class _RestaurantOrdersListScreenState
    extends State<RestaurantOrdersListScreen> {
  final RestaurantOrdersListController _con = RestaurantOrdersListController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context);
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
        child: Text('Restaurant Orders'),
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
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/img/no-image.png'),
                ),
                SizedBox(height: 15),
                Text(
                  'Nombre del usuario',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                ),
                Text(
                  'Telefono',
                  style: TextStyle(
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
          const ListTile(
            title: Text('Seleccionar rol'),
            trailing: Icon(Icons.person_outline),
          ),
          ListTile(
            onTap: _con.logout,
            title: const Text('Cerrar sesion'),
            trailing: const Icon(Icons.power_settings_new_outlined),
          ),
        ],
      ),
    );
  }
}
