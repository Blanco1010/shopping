import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/controllers/client/client_update_controller.dart';

import '../../Theme/theme.dart';
import '../../widgets/widgets.dart';

class ClientUpdateScreen extends StatefulWidget {
  const ClientUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ClientUpdateScreen> createState() => _ClientUpdateScreenState();
}

class _ClientUpdateScreenState extends State<ClientUpdateScreen> {
  final _con = ClientUpdateController();
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
        title: const Text('Editar perfil'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _con.back,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
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
                SizedBox(height: size.height * 0.1),
                _imageUser(size),
                SizedBox(height: size.height * 0.04),
                _textFieldFirstName(size, _con.firstNameController),
                SizedBox(height: size.height * 0.01),
                _textFieldLastName(size, _con.lastNameController),
                SizedBox(height: size.height * 0.01),
                _textFieldNumberPhone(size, _con.phoneNumberController),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: _buttonRegister(size, _con),
        padding: EdgeInsets.only(bottom: size.height * 0.02),
      ),
    );
  }

  Widget _imageUser(Size size) {
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundColor: MyColors.colorPrimary,
        backgroundImage: _con.user?.image != null
            ? NetworkImage(_con.user!.image)
            : _con.user?.image == null && _con.imageFile == null
                ? const AssetImage('assets/img/user.png')
                : FileImage(_con.imageFile!) as ImageProvider,
        radius: size.width * 0.15,
      ),
    );
  }

  _textFieldFirstName(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        validator: (value) {
          if (value.toString().isEmpty == true) {
            return 'Debes llenar el campo';
          }
        },
        icon: Icons.person_pin_circle_rounded,
        textController: textController,
        labelText: 'Nombre',
        formProperty: 'firstname',
        keyboardType: TextInputType.name,
      ),
    );
  }

  _textFieldLastName(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        validator: (value) {
          if (value.toString().isEmpty == true) {
            return 'Debes llenar el campo';
          }
        },
        icon: Icons.person_pin_circle_outlined,
        textController: textController,
        labelText: 'Apellido',
        formProperty: 'lastname',
        keyboardType: TextInputType.name,
      ),
    );
  }

  _textFieldNumberPhone(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        validator: null,
        icon: Icons.phone,
        textController: textController,
        labelText: 'Telefono ',
        formProperty: 'lastname',
        keyboardType: TextInputType.number,
      ),
    );
  }

  _buttonRegister(Size size, ClientUpdateController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _con.isLoading == false ? controller.update : null,
        child: const Text('Actualizar', style: TextStyle(fontSize: 25)),
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

  void refresh() {
    setState(() {});
  }
}