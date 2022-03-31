import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/screen/client/address/create/client_address_create_controller.dart';

import '../../../../Theme/theme.dart';
import '../../../../widgets/custom_input_field.dart';

class ClientAddressCreateScreen extends StatefulWidget {
  const ClientAddressCreateScreen({Key? key}) : super(key: key);

  @override
  _ClientAddressCreateScreenState createState() =>
      _ClientAddressCreateScreenState();
}

class _ClientAddressCreateScreenState extends State<ClientAddressCreateScreen> {
  final ClientAddressCreateController _con = ClientAddressCreateController();

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
        title: const Text('Nueva dirección'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            _textCompleteData(),
            Form(
              key: _con.formKey,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.08),
                  _textFieldAddress(size, _con.addressController),
                  SizedBox(height: size.height * 0.01),
                  _textFieldNeighborhood(size, _con.neighborhoodController),
                  SizedBox(height: size.height * 0.01),
                  _textFieldRefPoint(size, _con.refPointController),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _buttonAccept() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyColors.colorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () {
          _con.createAddress();
        },
        child: const Text(
          'CREAR',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _textFieldAddress(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        expand: false,
        max: 1,
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'Debes llenar el campo';
          }
        },
        icon: Icons.location_on,
        textController: textController,
        labelText: 'Dirección',
        keyboardType: TextInputType.text,
      ),
    );
  }

  _textFieldNeighborhood(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        expand: false,
        max: 1,
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'Debes llenar el campo';
          }
        },
        icon: Icons.location_city,
        textController: textController,
        labelText: 'Barrio',
        keyboardType: TextInputType.text,
      ),
    );
  }

  _textFieldRefPoint(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        onTap: _con.goToMap,
        maxLines: 1,
        cursorColor: const Color.fromARGB(255, 65, 65, 65),
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        controller: textController,
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'Debes llenar el campo';
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Color.fromARGB(255, 65, 65, 65)),
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          border: InputBorder.none,
          labelText: 'Punto de referencia',
          prefixIcon: Icon(
            Icons.map,
            color: Color.fromARGB(255, 65, 65, 65),
          ),
        ),
      ),
    );
  }

  Widget _textCompleteData() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 20, left: 10),
      child: const Text(
        'Completar los datos',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
