import 'package:shop_app/models/mercado_pago_credentials.dart';

class Environment {
  static const String apiDilevery = "192.168.68.110:3000";

  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
    publicKey: 'TEST-6c844655-0bf1-419b-a544-b87e2d1cf627',
    accessToken:
        'TEST-6880975183688953-020719-180685036245d485e099dc023058cb12-236807276',
  );
}
