import 'package:flutter/material.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/utils/relative_time_util.dart';
import 'package:shop_app/widgets/no_data_widget.dart';

import '../../controllers/restaurant/restaurant_orders_create_controller.dart';
import '../../models/order.dart';

class RestaurantOrderCreateScreen extends StatefulWidget {
  final Order order;
  const RestaurantOrderCreateScreen({Key? key, required this.order})
      : super(key: key);

  @override
  _RestaurantOrderCreateScreenState createState() =>
      _RestaurantOrderCreateScreenState();
}

class _RestaurantOrderCreateScreenState
    extends State<RestaurantOrderCreateScreen> {
  final RestaurantOrderCreateController _con =
      RestaurantOrderCreateController();

  @override
  void initState() {
    super.initState();

    _con.init(context, refresh, widget.order);
    // SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden #${_con.order!.id!}'),
        centerTitle: true,
      ),
      body: _con.order!.products!.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: _con.order!.products!.map((Product product) {
                      return _cardProduct(product);
                    }).toList(),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 10),
                      _textDescription(),
                      const SizedBox(height: 10),
                      _con.order!.status == 'PAGADO'
                          ? _dropDown(MediaQuery.of(context).size, refresh,
                              _con.listUser!)
                          : _deliveryData(_con.order!.delivery!),
                      const SizedBox(height: 5),
                      _textData('Cliente: ',
                          '${_con.order!.client!.name} ${_con.order!.client!.lastname}'),
                      const SizedBox(height: 5),
                      _textData('Entregar en: ', _con.order!.address!.address),
                      const SizedBox(height: 5),
                      _textData(
                        'Fecha de pedido: ',
                        RelativeTimeUtil.getRelativeTime(
                          _con.order!.timestamp!,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _textTotalPrice(),
                      const SizedBox(height: 10),
                      _con.order!.status == 'PAGADO'
                          ? _buttonNext()
                          : Container(),
                    ],
                  ),
                ),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: const NoDataWidget(
                text: 'Ningún producto agregado',
              ),
            ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          _con.updateOrder();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 35,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 60,
              child: const Center(
                child: Text(
                  'DESPACHAR ORDEN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        _con.order!.status == 'PAGADO'
            ? 'Asignar repartidor'
            : 'Repartidor asignado',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: MyColors.colorPrimary,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _textData(String title, String content) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: ListTile(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(content, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Row _cardProduct(Product product) {
    return Row(
      children: [
        _imageProduct(product),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cantidad: ${product.quantity}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _dropDown(Size size, Function refresh, List<User> users) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  itemHeight: 50,
                  alignment: Alignment.center,
                  icon: const Icon(Icons.arrow_drop_down_circle_sharp),
                  iconDisabledColor: Colors.grey,
                  iconEnabledColor: MyColors.colorPrimary,
                  elevation: 1,
                  isExpanded: true,
                  hint: const Text(
                    'Repartidores',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  items: _dropDownItems(users),
                  value: _con.idDelivery,
                  onChanged: (option) {
                    _con.idDelivery = option;

                    refresh();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    for (var element in users) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              height: 50,
              width: 50,
              child: element.image == null
                  ? const FadeInImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/img/no-image.png'),
                      placeholder: AssetImage('assets/gif/jar-loading.gif'),
                    )
                  : FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, url, error) =>
                          const Icon(Icons.error),
                      image: (element.image),
                      placeholder: ('assets/gif/jar-loading.gif'),
                    ),
            ),
            const SizedBox(width: 10),
            Text('${element.name} ${element.lastname}'),
          ],
        ),
        value: element.id,
      ));
    }
    return list;
  }

  Widget _deliveryData(User delivery) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          height: 50,
          width: 50,
          child: delivery.image == null
              ? const FadeInImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/img/no-image.png'),
                  placeholder: AssetImage('assets/gif/jar-loading.gif'),
                )
              : FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, url, error) =>
                      const Icon(Icons.error),
                  image: (delivery.image),
                  placeholder: ('assets/gif/jar-loading.gif'),
                ),
        ),
        const SizedBox(width: 10),
        Text('${_con.order!.delivery!.name} ${_con.order!.delivery!.lastname}'),
      ],
    );
  }

  Widget _textTotalPrice() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: const Text(
            'Total: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: Text(
            '\$ ${_con.total}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        )
      ],
    );
  }

  Container _imageProduct(Product product) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        color: Colors.grey[200],
      ),
      width: 70,
      height: 70,
      child: FadeInImage.assetNetwork(
        fit: BoxFit.fill,
        imageErrorBuilder: (context, url, error) => const Icon(Icons.error),
        image: product.imagen1!,
        placeholder: ('assets/gif/jar-loading.gif'),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
