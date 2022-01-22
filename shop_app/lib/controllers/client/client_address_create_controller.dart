import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/address.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:shop_app/provider/address_provider.dart';
import 'package:shop_app/screen/client/client_address_map_screen.dart';

import '../../models/user.dart';

class ClientAddressCreateController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late BuildContext context;
  late Function refresh;

  TextEditingController addressController = TextEditingController(text: '');

  TextEditingController neighborhoodController =
      TextEditingController(text: '');

  TextEditingController refPointController = TextEditingController(text: '');

  Map<String, dynamic>? refPointList;

  User? user;
  final SecureStogare _secureStogare = SecureStogare();

  final AddressProvider _addressProvider = AddressProvider();

  Future init(BuildContext context, Function refresh) async {
    this.refresh = refresh;
    this.context = context;
    user = User.fromJson(await _secureStogare.read('user'));
    _addressProvider.init(context, user!.sessionToken, user!.id!);
  }

  void createAddress() async {
    if (formKey.currentState!.validate()) {
      String address = addressController.text.trim();
      String neighborhood = neighborhoodController.text.trim();

      double lat = refPointList!['lat'] ?? 0;
      double lng = refPointList!['lng'] ?? 0;

      Address addressUser = Address(
        idUser: user!.id!,
        address: address,
        neightborhood: neighborhood,
        lat: lat,
        lng: lng,
      );

      ResponseApi responseApi = await _addressProvider.create(addressUser);

      if (responseApi.success) {
        // Snackbar.show(context, responseApi.message);

        addressUser.id = responseApi.data;
        _secureStogare.save('address', addressUser.toJson());

        Navigator.pop(context, true);
      }
    }
  }

  void goToMap() async {
    refPointList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ClientAddressMapScreen(),
      ),
    );

    if (refPointList != null) {
      refPointController.text = refPointList!['address'];
      refresh();
    }
  }
}
