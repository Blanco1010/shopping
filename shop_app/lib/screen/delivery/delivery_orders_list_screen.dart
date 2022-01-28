import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/models/order.dart';
import 'package:shop_app/utils/relative_time_util.dart';

import '../../controllers/delivery/delivery_orders_list_controller.dart';
import '../../widgets/no_data_widget.dart';

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
    _con.init(context, refresh);
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.status.length,
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
                _con.status.length,
                (index) => Tab(
                  child: Text(_con.status[index]),
                ),
              ),
            ),
          ),
        ),
        drawer: _drawer(),
        body: _con.status.isNotEmpty
            ? TabBarView(
                physics: const BouncingScrollPhysics(),
                children: _con.status.map((String status) {
                  return FutureBuilder(
                    future: _con.getOrders(status),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<Order>> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardOder(snapshot.data![index]);
                            },
                          );
                        } else {
                          return const NoDataWidget(text: 'No hay ordenes');
                        }
                      } else {
                        return const NoDataWidget(text: 'No hay ordenes');
                      }
                    },
                  );
                }).toList(),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _cardOder(Order order) {
    return GestureDetector(
      onTap: () => _con.goToPageOrders(order),
      child: Container(
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
                    child: Text(
                      'Orden #${order.id}',
                      style: const TextStyle(
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
                    child: Text(
                      'Fecha de pedido: ${RelativeTimeUtil.getRelativeTime(order.timestamp!)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      'Cliente: ${order.client!.name} ${order.client!.lastname}',
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      'Entregar en: ${order.address!.address}',
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
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

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: () => _con.openDrawer(),
      child: const Icon(Icons.menu, color: Colors.black),
    );
  }
}
