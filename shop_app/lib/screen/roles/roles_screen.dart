import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/roles/roles_controller.dart';
import 'package:shop_app/models/rol.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({Key? key}) : super(key: key);

  @override
  _RolesScreenState createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  final RolesController _con = RolesController();

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un rol'),
        centerTitle: true,
        backgroundColor: MyColors.colorPrimary,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ..._con.user?.roles != null
                ? _con.user!.roles!.map((e) => cardRol(e)).toList()
                : [],
          ],
        ),
      ),
    );
  }

  Widget cardRol(Rol rol) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _con.goToPage(rol.route),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: MyColors.colorPrimary),
            ),
            height: 150,
            width: 150,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: FadeInImage(
                image: NetworkImage(rol.image),
                placeholder: const AssetImage('assets/gif/jar-loading.gif'),
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 50),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          rol.name,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
