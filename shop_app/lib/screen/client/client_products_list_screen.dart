import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/client_product_list_controller.dart';

class ClientProductsListScreen extends StatefulWidget {
  const ClientProductsListScreen({Key? key}) : super(key: key);

  @override
  _ClientProductsListScreenState createState() =>
      _ClientProductsListScreenState();
}

class _ClientProductsListScreenState extends State<ClientProductsListScreen> {
  final ClientProductsListController _co = ClientProductsListController();
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _co.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: _co.key,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => _co.openDrawer(),
          child: const Icon(Icons.menu),
        ),
      ),
      drawer: _drawer(),
      body: const Center(),
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
            title: Text('Editar perfil'),
            trailing: Icon(
              Icons.edit_outlined,
            ),
          ),
          const ListTile(
            title: Text('Mis pedidos'),
            trailing: Icon(Icons.shopping_bag_outlined),
          ),
          const ListTile(
            title: Text('Seleccionar rol'),
            trailing: Icon(Icons.person_outline),
          ),
          ListTile(
            onTap: _co.logout,
            title: const Text('Cerrar sesion'),
            trailing: const Icon(Icons.power_settings_new_outlined),
          ),
        ],
      ),
    );
  }
}
