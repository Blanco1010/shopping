import 'package:flutter/material.dart';
import 'package:shop_app/screen/client/client_address_map_screen.dart';

class ClientAddressCreateController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late BuildContext context;
  late Function refresh;

  TextEditingController addressController = TextEditingController(text: '');

  TextEditingController neighborhoodController =
      TextEditingController(text: '');

  TextEditingController refPointController = TextEditingController(text: '');

  Map<String, dynamic>? refPoint;

  Future init(BuildContext context, Function refresh) async {
    this.refresh = refresh;
    this.context = context;
  }

  void createAddress() async {
    if (formKey.currentState!.validate()) {
      String address = addressController.text.trim();
      String neighborhood = neighborhoodController.text.trim();
      String refPoint = refPointController.text.trim();

      print(address);
      print(neighborhood);
      print(refPoint);
    }
  }

  void goToMap() async {
    refPoint = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ClientAddressMapScreen(),
      ),
    );

    if (refPoint != null) {
      refPointController.text = refPoint!['address'];
      refresh();
    }

    print(refPoint);
  }
}
