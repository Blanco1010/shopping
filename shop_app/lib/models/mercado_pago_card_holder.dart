class MercadoPagoCardHolder {
  //NOMBRE
  late String name;

  //NUMERO DE IDENTIFICACION
  late int number;

  //SUBTIPO DE IDENTIFICACION
  late String? subtype;

  //TIPO DE IDENTIFICACION
  late String? type;

  late List<MercadoPagoCardHolder> cardHolderList = [];

  MercadoPagoCardHolder();

  MercadoPagoCardHolder.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return;
    }
    for (var item in jsonList) {
      final chat = MercadoPagoCardHolder.fromJsonMap(item);
      cardHolderList.add(chat);
    }
  }

  MercadoPagoCardHolder.fromJsonMap(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    number = json['identification'] != null
        ? (json['identification']['number'] != null)
            ? int.parse(json['identification']['number'].toString())
            : 0
        : 0;
    subtype =
        json['identification'] != null ? json['identification']['subtype'] : '';
    type =
        json['identification'] != null ? json['identification']['type'] : null;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'subtype': subtype,
        'type': type,
      };
}
