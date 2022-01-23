import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/restaurant/restaurant_orders_list_controller.dart';
import 'package:shop_app/models/order.dart';

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
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.categories.length,
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              children: [
                const SizedBox(height: 37),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    _menuDrawer(),
                  ],
                ),
              ],
            ),
            bottom: TabBar(
              physics: const BouncingScrollPhysics(),
              indicatorColor: MyColors.colorPrimary,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List.generate(
                _con.categories.length,
                (index) => Tab(
                  child: Text(_con.categories[index]),
                ),
              ),
            ),
          ),
        ),
        drawer: _drawer(),
        body: _con.categories.isNotEmpty
            ? TabBarView(
                physics: const BouncingScrollPhysics(),
                children: _con.categories.map((String e) {
                  return _cardOder(null);
                  // return FutureBuilder(
                  //   future: _con.getProducts(e.id!),
                  //   builder: (
                  //     BuildContext context,
                  //     AsyncSnapshot<List<Product>> snapshot,
                  //   ) {
                  //     if (snapshot.hasData) {
                  //       if (snapshot.data!.isNotEmpty) {
                  //         return GridView.builder(
                  //           physics: const BouncingScrollPhysics(),
                  //           keyboardDismissBehavior:
                  //               ScrollViewKeyboardDismissBehavior.onDrag,
                  //           gridDelegate:
                  //               const SliverGridDelegateWithFixedCrossAxisCount(
                  //             crossAxisCount: 2,
                  //             childAspectRatio: 0.7,
                  //           ),
                  //           itemCount: snapshot.data?.length ?? 0,
                  //           itemBuilder: (_, index) {
                  //             return _cardShopping(snapshot.data![index]);
                  //           },
                  //         );
                  //       } else {
                  //         return const NoDataWidget(text: 'No hay productos');
                  //       }
                  //     } else {
                  //       return const NoDataWidget(text: 'No hay productos');
                  //     }
                  //   },
                  // );
                }).toList(),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _cardOder(Order? order) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: MyColors.colorPrimary,
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    'Orden #0',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 20),
                  child: const Text(
                    'Pedido: 2015_05-23',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 20),
                  child: const Text(
                    'Cliente: Jonathan',
                    style: TextStyle(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 20),
                  child: const Text(
                    'Entregar en: Calle false Carrera falsa',
                    style: TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          ],
        ),
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
                SizedBox(
                  height: 60,
                  width: 60,
                  child: _con.user?.image == null
                      ? const FadeInImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/img/no-image.png'),
                          placeholder: AssetImage('assets/gif/jar-loading.gif'),
                        )
                      : FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, url, error) =>
                              const Icon(Icons.error),
                          image: (_con.user!.image),
                          placeholder: ('assets/gif/jar-loading.gif'),
                        ),
                ),
                // CircleAvatar(
                //   radius: 30,
                //   backgroundColor: Colors.transparent,
                //   backgroundImage: _con.user?.image == null
                //       ? const AssetImage('assets/img/no-image.png')
                //       : NetworkImage(_con.user!.image) as ImageProvider,
                // ),
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
            onTap: _con.goToCategoryCreate,
            title: const Text('Crear categoria'),
            trailing: const Icon(Icons.list_alt),
          ),
          ListTile(
            onTap: _con.goToProductCreate,
            title: const Text('Crear producto'),
            trailing: const Icon(Icons.local_pizza),
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

  void refresh() {
    setState(() {});
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: () => _con.openDrawer(),
      child: const Icon(Icons.menu, color: Colors.black),
    );
  }
}
