import 'package:contatos/models/dto/endereco_dto.dart';

abstract class IViaCepService {
  Future<EnderecoDto> buscarPorCep(String cep);

  Future<List<EnderecoDto>> buscarPorPesquisa(
    String uf,
    String cidade,
    String logradouro,
  );
}
