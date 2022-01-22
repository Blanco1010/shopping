import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/client/client_orders_create_controller.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/widgets/no_data_widget.dart';

class ClientOrderCreateScreen extends StatefulWidget {
  const ClientOrderCreateScreen({Key? key}) : super(key: key);

  @override
  _ClientOrderCreateScreenState createState() =>
      _ClientOrderCreateScreenState();
}

class _ClientOrderCreateScreenState extends State<ClientOrderCreateScreen> {
  final ClientOrderCreateController _con = ClientOrderCreateController();

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
      appBar: AppBar(
        title: const Text('Mi orden'),
        centerTitle: true,
      ),
      body: _con.selectProducts.isNotEmpty
          ? ListView(
              physics: const BouncingScrollPhysics(),
              children: _con.selectProducts.map((Product product) {
                return _cardProduct(product);
              }).toList())
          : Container(
              alignment: Alignment.center,
              child: const NoDataWidget(
                text: 'Ningún producto agregado',
              ),
            ),
      bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            children: [
              Divider(
                color: Colors.grey[400],
                endIndent: 30,
                indent: 30,
              ),
              _textTotalPrice(),
              _buttonNext(),
            ],
          )),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () => _con.goToAddress(),
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
              color: Colors.green,
              size: 35,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 70,
              child: const Center(
                child: Text(
                  'CONFIRMAR ORDEN',
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
            _addOrRemove(product),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _textPrice(product),
            _iconDelete(product),
          ],
        ),
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

  Widget _iconDelete(Product product) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10),
      child: GestureDetector(
        onTap: () => _con.deleteItem(product),
        child: Icon(
          Icons.delete,
          color: MyColors.colorPrimary,
          size: 25,
        ),
      ),
    );
  }

  Widget _textPrice(Product product) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Text(
        '\$ ${product.price * product.quantity!}',
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
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
      width: 90,
      height: 90,
      child: FadeInImage.assetNetwork(
        fit: BoxFit.fill,
        imageErrorBuilder: (context, url, error) => const Icon(Icons.error),
        image: product.imagen1!,
        placeholder: ('assets/gif/jar-loading.gif'),
      ),
    );
  }

  Row _addOrRemove(Product product) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _con.removeItem(product),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: const Text('-'),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: Text(product.quantity.toString()),
        ),
        GestureDetector(
          onTap: () => _con.addItem(product),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: const Text('+'),
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
