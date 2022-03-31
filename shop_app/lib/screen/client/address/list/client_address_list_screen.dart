import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/models/address.dart';
import 'package:shop_app/widgets/no_data_widget.dart';
import 'client_address_list_controller.dart';

class ClientAddressListScreen extends StatefulWidget {
  const ClientAddressListScreen({
    Key? key,
    required this.total,
  }) : super(key: key);
  final int total;

  @override
  _ClientAddressListScreenState createState() =>
      _ClientAddressListScreenState();
}

class _ClientAddressListScreenState extends State<ClientAddressListScreen> {
  final ClientAddressListController _con = ClientAddressListController();

  @override
  void initState() {
    super.initState();
    _con.init(context, refresh, widget.total);
    // SchedulerBinding.instance!.addPostFrameCallback((timeStamp)
    //  {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dirección'),
        centerTitle: true,
        actions: [
          _iconAdd(),
        ],
      ),
      body: Column(children: [
        _textSelectAddress(),
        Expanded(child: _listAddress()),
      ]),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _noAddress() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 50),
          child: const NoDataWidget(text: 'Agregar una nueva dirección'),
        ),
        _buttonNewAddress(),
      ],
    );
  }

  Widget _listAddress() {
    return FutureBuilder(
      future: _con.getAddress(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Address>> snapshot,
      ) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (_, index) {
                return _radioSelectorAddress(
                  snapshot.data![index],
                  index,
                );
              },
            );
          } else {
            return _noAddress();
          }
        } else {
          return _noAddress();
        }
      },
    );
  }

  Widget _radioSelectorAddress(Address address, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Radio(
            value: index,
            groupValue: _con.radioValue,
            onChanged: (value) {
              _con.handleRadoiValueChange(index);
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.address,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                address.neightborhood,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              debugPrint(_con.address[index].id);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.delete,
                color: MyColors.colorPrimary,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonNewAddress() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
        ),
        onPressed: () {
          _con.goToNewAddress();
        },
        child: const Text(
          'Nueva dirección',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buttonAccept() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(25.0),
        onTap: () {
          _con.createOrder();
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: MyColors.colorPrimary,
          ),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: const Center(
            child: Text(
              'PAGAR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _textSelectAddress() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20),
      child: const Text(
        'Elige donde recibir tus compras',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container _iconAdd() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => _con.goToNewAddress(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
