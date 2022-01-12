import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/client/client_product_list_controller.dart';
import 'package:shop_app/models/category.dart';

class ClientProductsListScreen extends StatefulWidget {
  const ClientProductsListScreen({Key? key}) : super(key: key);

  @override
  _ClientProductsListScreenState createState() =>
      _ClientProductsListScreenState();
}

class _ClientProductsListScreenState extends State<ClientProductsListScreen> {
  final ClientProductsListController _con = ClientProductsListController();
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.categorys.length,
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(170),
          child: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              _shoppingBag(),
            ],
            flexibleSpace: Column(
              children: [
                const SizedBox(height: 37),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    _menuDrawer(),
                  ],
                ),
                const SizedBox(height: 12),
                _textFielfSearch(),
              ],
            ),
            bottom: TabBar(
              physics: const BouncingScrollPhysics(),
              indicatorColor: MyColors.colorPrimary,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List.generate(
                _con.categorys.length,
                (index) => Tab(
                  child: Text(_con.categorys[index].name),
                ),
              ),
            ),
          ),
        ),
        drawer: _drawer(),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: _con.categorys.map((e) {
            return Center(
              child: Text(e.name),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: () => _con.openDrawer(),
      child: const Icon(Icons.menu, color: Colors.black),
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
          ListTile(
            title: const Text('Editar perfil'),
            trailing: const Icon(
              Icons.edit_outlined,
            ),
            onTap: _con.goToUpdate,
          ),
          const ListTile(
            title: Text('Mis pedidos'),
            trailing: Icon(Icons.shopping_bag_outlined),
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

  Widget _shoppingBag() {
    return Container(
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.04,
        top: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Stack(
        children: [
          const Icon(
            Icons.shopping_bag,
            color: Colors.black,
          ),
          Positioned(
            right: 0,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _textFielfSearch() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Buscar',
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey[500],
            ),
            hintStyle: TextStyle(
              fontSize: 17,
              color: Colors.grey[500],
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            contentPadding: const EdgeInsets.all(15)),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
