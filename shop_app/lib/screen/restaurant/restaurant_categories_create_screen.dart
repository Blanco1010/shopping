import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/controllers/restaurant/restaurant_categories_create_controller.dart';

import '../../Theme/theme.dart';
import '../../widgets/widgets.dart';

class RestaurantCategoriesCreateScreen extends StatefulWidget {
  const RestaurantCategoriesCreateScreen({Key? key}) : super(key: key);

  @override
  _RestaurantCategoriesCreateScreenState createState() =>
      _RestaurantCategoriesCreateScreenState();
}

class _RestaurantCategoriesCreateScreenState
    extends State<RestaurantCategoriesCreateScreen> {
  final RestaurantCategoriesCreateController _con =
      RestaurantCategoriesCreateController();

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
        title: const Text('Nueva Categoria'),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => _con.goToRoles(),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SizedBox(
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
        return null;
      },
      icon: Icons.info_outline,
      textController: textController,
      labelText: 'Nombre de la categoría',
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
      max: 5,
      maxLength: 255,
      validator: (value) {
        if (value.toString().isEmpty == true) {
          return 'Debes llenar el campo';
        }
        return null;
      },
      icon: Icons.description,
      textController: textController,
      labelText: 'Descripción',
      keyboardType: TextInputType.multiline,
    ),
  );
}

_buttonCreate(Size size, RestaurantCategoriesCreateController con) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: size.width * 0.15,
      vertical: size.height * 0.02,
    ),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: con.createCategory,
      child: const Text('Crear categoría', style: TextStyle(fontSize: 25)),
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
