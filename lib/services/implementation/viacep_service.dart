import 'package:contatos/helpers/string_helper.dart';
import 'package:contatos/models/dto/endereco_dto.dart';
import 'package:contatos/services/interface/i_viacep_service.dart';
import 'package:contatos/utils/excecoes_util.dart';
import 'package:dio/dio.dart';

class ViaCepService implements IViaCepService {
  static const String _urlBase = "https://viacep.com.br/ws/";

  final Dio _requisicao;

  ViaCepService(this._requisicao);

  @override
  Future<EnderecoDto> buscarPorCep(String cep) async {
    if (cep.length != 8) {
      throw FormatoInvalidoExcecao(mensagem: "Cep deve conter 8 digitos!");
    }

    if (!cep.toCharArray().every((caracteres) => caracteres.isNumeric)) {
      throw FormatoInvalidoExcecao(mensagem: "Cep deve conter apenas números!");
    }

    Response resultado = await _requisicao.get("$_urlBase$cep/json/");

    if (resultado.data is Map && (resultado.data as Map).containsKey("erro")) {
      throw NenhumResultadoExcecao();
    }

    return EnderecoDto.fromMap(resultado.data);
  }

  @override
  Future<List<EnderecoDto>> buscarPorPesquisa(
    String uf,
    String cidade,
    String logradouro,
  ) async {
    // validar informações
    if (uf.isEmpty) {
      throw FormatoInvalidoExcecao(mensagem: "Uf não informada!");
    }

    if (cidade.isEmpty) {
      throw FormatoInvalidoExcecao(mensagem: "Cidade não informada");
    }

    if (logradouro.isEmpty || logradouro.length < 3) {
      throw FormatoInvalidoExcecao(
        mensagem: "Logradouro deve conter pelo menos 3 caracteres!",
      );
    }

    Response resultado = await _requisicao.get(
      "$_urlBase$uf/$cidade/$logradouro/json/",
    );

    return (resultado.data as List)
        .map((e) => e as Map<String, dynamic>)
        .map(EnderecoDto.fromMap)
        .toList();
  }
}
