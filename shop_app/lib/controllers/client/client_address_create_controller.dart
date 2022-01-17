import 'package:flutter/material.dart';

class ClientAddressCreateController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late BuildContext context;
  late Function refresh;

  TextEditingController addressController = TextEditingController(text: '');

  TextEditingController neighborhoodController =
      TextEditingController(text: '');

  TextEditingController referencePointController =
      TextEditingController(text: '');

  Future init(BuildContext context, Function refresh) async {
    this.refresh = refresh;
    this.context = context;
  }

  void createAddress() async {
    if (formKey.currentState!.validate()) {
      String address = addressController.text.trim();
      String neighborhood = neighborhoodController.text.trim();
      String refPoint = referencePointController.text.trim();

      print(address);
      print(neighborhood);
      print(refPoint);
    }
  }

  void goToMap() {
    Navigator.pushNamed(context, '/client/address/map');
  }
}
