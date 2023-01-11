import 'dart:convert';

class CriptografiaUtil {
  CriptografiaUtil._();

  static String criptografar(String valor) {
    final bytes = utf8.encode(valor);

    return base64Encode(bytes);
  }

  static String decriptografar(String valor) {
    final bytes = base64Decode(valor);

    return utf8.decode(bytes);
  }
}
