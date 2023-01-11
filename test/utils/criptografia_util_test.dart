import 'package:contatos/utils/criptografia_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Criptografia", () {
    test("Criptografar", () {
      var criptografado = CriptografiaUtil.criptografar("Hello hord");

      expect(criptografado, equals("SGVsbG8gaG9yZA=="));
    });

    test("Descriptografar", () {
      var criptografado = CriptografiaUtil.criptografar("Hello hord");

      var decriptografado = CriptografiaUtil.decriptografar(criptografado);

      expect(decriptografado, equals("Hello hord"));
    });
  });
}
