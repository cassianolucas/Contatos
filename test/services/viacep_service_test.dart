import 'package:contatos/services/implementation/viacep_service.dart';
import 'package:contatos/utils/excecoes_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var servico = ViaCepService(Dio());

  group("Teste de api com \"ViaCep\"", () {
    test("Buscar por cep", () async {
      var endereco = await servico.buscarPorCep("83606390");

      expect(endereco, isNotNull);
    });

    test("Buscar por cep digitos faltantes", () {
      expect(
        servico.buscarPorCep("8360639"),
        throwsA(isA<FormatoInvalidoExcecao>()),
      );
    });

    test("Buscar por cep com alfanuméricos", () {
      expect(
        servico.buscarPorCep("836060aaa"),
        throwsA(isA<FormatoInvalidoExcecao>()),
      );
    });

    test("Buscar por cep inexistente", () async {
      expect(
        servico.buscarPorCep("99999999"),
        throwsA(isA<NenhumResultadoExcecao>()),
      );
    });

    test("Buscar por uf + cidade + inicio logradouro", () async {
      var enderecos = await servico.buscarPorPesquisa(
        "pr",
        "Campo largo",
        "ayrton",
      );

      expect(enderecos, isNotNull);

      expect(enderecos.length, equals(1));
    });
  });
}
