import 'package:shop_app/models/mercado_pago_credentials.dart';

class Environment {
  static const String apiDilevery = "192.168.68.110:3000";

  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
    publicKey: 'TEST-287ac894-02b0-4ff2-a2b3-c09cd33f7e29',
    accessToken:
        'TEST-1057111017086158-090515-af624e8e9e128f87b66ec915dcfc7610-236807276',
  );
}
