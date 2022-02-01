import 'package:flutter/material.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/client/client_order_detail_controller.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/utils/relative_time_util.dart';
import 'package:shop_app/widgets/no_data_widget.dart';
import '../../models/order.dart';

class ClientOrderDetailScreen extends StatefulWidget {
  final Order order;
  const ClientOrderDetailScreen({Key? key, required this.order})
      : super(key: key);

  @override
  _ClientOrderDetailScreenState createState() =>
      _ClientOrderDetailScreenState();
}

class _ClientOrderDetailScreenState extends State<ClientOrderDetailScreen> {
  final ClientOrderDetailCreateController _con =
      ClientOrderDetailCreateController();

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
                      _deliveryData(_con.order!.delivery!),
                      const SizedBox(height: 5),
                      _con.order?.delivery?.id != null
                          ? _textData('Repartidor: ',
                              '${_con.order!.delivery!.name} ${_con.order!.delivery!.lastname}')
                          : _textData('Repartidor: ', 'No asignado'),
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
                      _con.order?.status == 'EN CAMINO'
                          ? _buttonNext()
                          : Container()
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
          primary: MyColors.colorPrimary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_sharp,
              color: Colors.white,
              size: 35,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 60,
              child: const Center(
                child: Text(
                  'SEGUIR ENTREGA',
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
