import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/screen/client/products/list/client_product_list_controller.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/widgets/no_data_widget.dart';

import '../../../../models/category.dart';

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

    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
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
        body: _con.categorys.isNotEmpty
            ? TabBarView(
                physics: const BouncingScrollPhysics(),
                children: _con.categorys.map((Category e) {
                  return FutureBuilder(
                    future: _con.getProducts(e.id!, _con.productName),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<Product>> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardShopping(snapshot.data![index]);
                            },
                          );
                        } else {
                          return const NoDataWidget(text: 'No hay productos');
                        }
                      } else {
                        return const NoDataWidget(text: 'No hay productos');
                      }
                    },
                  );
                }).toList(),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _cardShopping(Product product) {
    return GestureDetector(
      onTap: () => _con.goToProductDetail(product),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: FadeInImage(
                    fit: BoxFit.fill,
                    image: product.imagen1 != null
                        ? NetworkImage(product.imagen1!) as ImageProvider
                        : const AssetImage('assets/img/no-image.png'),
                    placeholder: const AssetImage('assets/gif/jar-loading.gif'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  height: 40,
                  child: Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '\$ ${product.price}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              child: Container(
                child: const Icon(Icons.add, color: Colors.white),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: MyColors.colorPrimary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
              ),
            ),
          ],
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
          ListTile(
            title: const Text('Editar perfil'),
            trailing: const Icon(
              Icons.edit_outlined,
            ),
            onTap: _con.goToUpdate,
          ),
          ListTile(
            title: const Text('Mis Pedidos'),
            trailing: const Icon(
              Icons.shopping_bag,
            ),
            onTap: _con.goToOrdersList,
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
    return GestureDetector(
      onTap: () => _con.goToOrderCreateScreen(),
      child: Container(
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
      ),
    );
  }

  Widget _textFielfSearch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: _con.onChangeText,
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
