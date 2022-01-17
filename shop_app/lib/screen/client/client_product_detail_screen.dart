import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/client/client_product_detail_controller.dart';

import '../../models/product.dart';
import '../../widgets/slideshow_widget.dart';

class ClientProductDetailScreen extends StatefulWidget {
  final Product product;
  const ClientProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  _ClientProductDetailState createState() => _ClientProductDetailState();
}

class _ClientProductDetailState extends State<ClientProductDetailScreen> {
  final ClientProductDetailController _clientProductDetailController =
      ClientProductDetailController();

  @override
  void initState() {
    super.initState();

    _clientProductDetailController.init(context, refresh, widget.product);
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Slideshow(
                  pointUp: false,
                  colorPrimary: MyColors.colorPrimary,
                  colorSecondary: Colors.grey,
                  bulletPrimary: 0.05,
                  bulletSecondary: 0.03,
                  slides: [
                    FadeInImage.assetNetwork(
                      image: _clientProductDetailController.product.imagen1!,
                      fit: BoxFit.fill,
                      placeholder: 'assets/gif/jar-loading.gif',
                      imageErrorBuilder: (context, error, stackTrace) =>
                          const Icon(
                        Icons.warning_amber_sharp,
                      ),
                    ),
                    FadeInImage.assetNetwork(
                      image: _clientProductDetailController.product.imagen2!,
                      fit: BoxFit.fill,
                      placeholder: 'assets/gif/jar-loading.gif',
                      imageErrorBuilder: (context, error, stackTrace) =>
                          const Icon(
                        Icons.warning_amber_sharp,
                      ),
                    ),
                    FadeInImage.assetNetwork(
                      image: _clientProductDetailController.product.imagen3!,
                      fit: BoxFit.fill,
                      placeholder: 'assets/gif/jar-loading.gif',
                      imageErrorBuilder: (context, error, stackTrace) =>
                          const Icon(
                        Icons.warning_amber_sharp,
                      ),
                    ),
                  ],
                ),
              ),
              _textName(),
              _textDescription(),
              const Spacer(),
              _addOrRemove(),
              _standartDelivery(),
              _buttonShopping(),
            ],
          ),
          Positioned(
            top: 40,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 40,
                color: MyColors.colorPrimary,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _textName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 20, top: 20),
      child: Text(
        _clientProductDetailController.product.name,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buttonShopping() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          _clientProductDetailController.addToBag();
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const SizedBox(
          height: 70,
          child: Center(
            child: Text(
              'AGREGAR A LA BOLSA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _standartDelivery() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 20, top: 10),
      child: const Text(
        'Envio estandar',
        style: TextStyle(
          fontSize: 15,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _addOrRemove() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _clientProductDetailController.addItem();
            },
            child: Icon(
              Icons.add_circle_outline,
              size: 40,
              color: MyColors.colorPrimary,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              '${_clientProductDetailController.counter}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _clientProductDetailController.removeItem();
            },
            child: Icon(
              Icons.remove_circle_outline,
              size: 40,
              color: MyColors.colorPrimary,
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Text(
              '\$${_clientProductDetailController.price}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 20, top: 20),
      child: Text(
        _clientProductDetailController.product.description,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
