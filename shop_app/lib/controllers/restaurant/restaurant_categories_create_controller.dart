import 'package:flutter/material.dart';

import 'package:shop_app/controllers/secure_storage.dart';

import 'package:shop_app/models/category.dart';

import 'package:shop_app/models/response_model.dart';

import 'package:shop_app/provider/category_provider.dart';

import '../../models/user.dart';
import '../../widgets/widgets.dart';

class RestaurantCategoriesCreateController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  BuildContext? context;

  bool isLoading = false;

  late Function refresh;

  TextEditingController titleController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');

  final CategoryProvider _categoryProvider = CategoryProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    User user = User.fromJson(await SecureStogare().read('user'));
    _categoryProvider.init(context, user.sessionToken, user.id!);
  }

  void createCategory() async {
    if (formKey.currentState!.validate()) {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();

      print(title);
      print(description);

      Category categoty = Category(name: title, description: description);
      ResponseApi responseApi = await _categoryProvider.create(categoty);

      if (responseApi.success == true) {
        titleController.text = '';
        descriptionController.text = '';
        Snackbar.show(context, responseApi.message);
      } else {
        Snackbar.show(context, responseApi.message);
      }
    }
  }
}
