import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/client/client_orders_list_controller.dart';
import 'package:shop_app/models/order.dart';
import 'package:shop_app/utils/relative_time_util.dart';
import '../../widgets/no_data_widget.dart';

class ClientOrdersListScreen extends StatefulWidget {
  const ClientOrdersListScreen({Key? key}) : super(key: key);

  @override
  _ClientOrdersListScreenState createState() => _ClientOrdersListScreenState();
}

class _ClientOrdersListScreenState extends State<ClientOrdersListScreen> {
  final ClientOrdersListController _con = ClientOrdersListController();

  @override
  void initState() {
    super.initState();
    _con.init(context, refresh);
    // SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {});
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
            title: const Text('Mis pedidos'),
            centerTitle: true,
            backgroundColor: MyColors.colorPrimary,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new),
            ),
            bottom: TabBar(
              physics: const BouncingScrollPhysics(),
              indicatorColor: MyColors.colorPrimary,
              labelColor: Colors.white,
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
                    child: order.delivery!.id != null
                        ? Text(
                            'Repartidor: ${order.delivery!.name} ${order.delivery!.lastname}',
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const Text(
                            'Repartidor: No asignado',
                            style: TextStyle(fontSize: 13),
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

  void refresh() {
    setState(() {});
  }
}
