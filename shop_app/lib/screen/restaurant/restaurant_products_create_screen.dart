import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/models/category.dart';

import 'package:shop_app/controllers/restaurant/restaurant_products_create_controller.dart';

import '../../Theme/theme.dart';
import '../../widgets/widgets.dart';

class RestaurantProductsCreateScreen extends StatefulWidget {
  const RestaurantProductsCreateScreen({Key? key}) : super(key: key);

  @override
  _RestaurantProductsCreateScreenState createState() =>
      _RestaurantProductsCreateScreenState();
}

class _RestaurantProductsCreateScreenState
    extends State<RestaurantProductsCreateScreen> {
  final RestaurantProductsCreateController _con =
      RestaurantProductsCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Producto'),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => _con.goToRoles(),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _con.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.04),
                _textFieldTitle(size, _con.titleController),
                SizedBox(height: size.height * 0.01),
                _textFieldDescription(size, _con.descriptionController),
                SizedBox(height: size.height * 0.01),
                _textFieldPrice(size, _con.priceController),
                SizedBox(height: size.height * 0.01),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: _cardImage(_con.imageFile1, 1, context, _con)),
                      Flexible(
                          child: _cardImage(_con.imageFile2, 2, context, _con)),
                      Flexible(
                          child: _cardImage(_con.imageFile3, 3, context, _con)),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                _dropDownCategories(_con, size, refresh),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buttonCreate(MediaQuery.of(context).size, _con),
    );
  }

  void refresh() {
    setState(() {});
  }
}

_textFieldTitle(Size size, TextEditingController textController) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
    decoration: BoxDecoration(
      color: MyColors.primaryOpactyColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: CustomInputField(
      expand: false,
      validator: (value) {
        if (value.toString().isEmpty == true) {
          return 'Debes llenar el campo';
        }
      },
      icon: Icons.local_pizza_rounded,
      textController: textController,
      labelText: 'Nombre de producto',
      keyboardType: TextInputType.name,
    ),
  );
}

_textFieldDescription(Size size, TextEditingController textController) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
    decoration: BoxDecoration(
      color: MyColors.primaryOpactyColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: CustomInputField(
      expand: false,
      max: 3,
      maxLength: 255,
      validator: (value) {
        if (value.toString().isEmpty == true) {
          return 'Debes llenar el campo';
        }
      },
      icon: Icons.description,
      textController: textController,
      labelText: 'Descripción',
      keyboardType: TextInputType.multiline,
    ),
  );
}

_textFieldPrice(Size size, TextEditingController textController) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
    decoration: BoxDecoration(
      color: MyColors.primaryOpactyColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: CustomInputField(
      expand: false,
      validator: (value) {
        if (value.toString().isEmpty == true) {
          return 'Debes llenar el campo';
        }

        if (RegExp(r'^[0-9]+([0-9]+)?$').hasMatch(value!) == false) {
          return 'Debes introducir solo los números';
        }
      },
      icon: Icons.monetization_on,
      textController: textController,
      labelText: 'Precio',
      keyboardType: TextInputType.number,
    ),
  );
}

_cardImage(File? imageFile, int numberFile, BuildContext context,
    RestaurantProductsCreateController con) {
  return GestureDetector(
    onTap: () {
      con.showAlertDialog(numberFile);
    },
    child: imageFile != null
        ? Card(
            elevation: 3.0,
            child: SizedBox(
              height: 100,
              child: Image.file(
                imageFile,
                fit: BoxFit.fill,
              ),
            ),
          )
        : const Card(
            elevation: 3.0,
            child: SizedBox(
              height: 100,
              child: Image(
                image: AssetImage('assets/img/add-image.png'),
              ),
            ),
          ),
  );
}

_dropDownCategories(
    RestaurantProductsCreateController con, Size size, Function refresh) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: size.width * 0.10),
    child: Material(
      elevation: 2.0,
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Material(
                  elevation: 0,
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  child: Icon(
                    Icons.search,
                    color: MyColors.colorPrimary,
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'Categorías',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: DropdownButton<String>(
                alignment: Alignment.center,
                icon: const Icon(Icons.arrow_drop_down_circle_sharp),
                iconDisabledColor: Colors.grey,
                iconEnabledColor: MyColors.colorPrimary,
                elevation: 3,
                isExpanded: true,
                hint: const Text(
                  'Seleccionar categoria',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                items: _dropDownItems(con.categories),
                value: con.idCategory,
                onChanged: (option) {
                  con.idCategory = option;
                  refresh();
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
  List<DropdownMenuItem<String>> list = [];
  for (var element in categories) {
    list.add(DropdownMenuItem(
      child: Text(element.name),
      value: element.id,
    ));
  }
  return list;
}

_buttonCreate(Size size, RestaurantProductsCreateController con) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: size.width * 0.15,
      vertical: size.height * 0.02,
    ),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: con.createProduct,
      child: const Text('Crear producto', style: TextStyle(fontSize: 25)),
      style: ElevatedButton.styleFrom(
        primary: MyColors.colorPrimary,
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.02,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
    ),
  );
}
