import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/address.dart';

import 'package:shop_app/provider/address_provider.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/provider/stripeProvider.dart';

import '../../../../models/order.dart';
import '../../../../models/product.dart';
import '../../../../models/response_model.dart';
import '../../../../models/user.dart';

class ClientAddressListController {
  late BuildContext context;
  late Function refresh;
  List<Address> address = [];
  final AddressProvider _addressProvider = AddressProvider();
  User? user;
  List<Product> selectProducts = [];
  int radioValue = 0;
  int total = 0;

  final OrderProvider _orderProvider = OrderProvider();

  final StripeProvider _stripeProvider = StripeProvider();

  final SecureStogare _secureStogare = SecureStogare();

  Future init(BuildContext context, Function refresh, int total) async {
    this.total = total;
    this.refresh = refresh;
    this.context = context;
    user = User.fromJson(await SecureStogare().read('user'));
    _addressProvider.init(context, user!.sessionToken!, user!.id!);
    _orderProvider.init(context, user!.sessionToken!, user!.id!);
    // _stripeProvider.init();
    refresh();
  }

  void createOrder() async {
    // _showLoadingIndicator(context);
    var responseStripe =
        await _stripeProvider.payWithCard(total.toString(), 'COP');
    // Navigator.pop(context);
    debugPrint('$responseStripe');
    if (responseStripe!.success) {
      Address a = Address.fromJson(await _secureStogare.read('address'));

      for (var item
          in json.decode(await _secureStogare.read('order'))?.toList() ?? []) {
        selectProducts.add(
          Product.fromJson(item),
        );
      }

      Order order = Order(
        idAddress: a.id!,
        idClient: user!.id!,
        lat: a.lat,
        lng: a.lng,
        products: selectProducts,
        status: '',
        timestamp: null,
      );

      ResponseApi responseApi = await _orderProvider.create(order);
      selectProducts.clear();

      if (responseApi.success) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/client/payment/status',
          (route) => false,
        );
      }
    }
  }

  void handleRadoiValueChange(int value) {
    radioValue = value;
    _secureStogare.save('address', address[value].toJson());
    refresh();
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser();
    Address a;
    int index = 0;

    if (await _secureStogare.read('address') != 'null') {
      a = Address.fromJson(await _secureStogare.read('address'));
      index = address.indexWhere((element) => element.id == a.id);
    }

    if (index != -1) {
      radioValue = index;
    }
    debugPrint('$index');
    return address;
  }

  void goToNewAddress() async {
    var result = await Navigator.pushNamed(context, '/client/address/create');

    if (result != null) {
      if (result as bool) {
        refresh();
      }
    }
  }
}

// Future<dynamic> showLoadingIndicator(BuildContext context) {
//   return showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return WillPopScope(
//         onWillPop: () async => false,
//         child: const AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(25.0)),
//           ),
//           backgroundColor: Colors.black,
//           content: LoadingIndicator(text: 'Espere un momento'),
//         ),
//       );
//     },
//   );
// }
