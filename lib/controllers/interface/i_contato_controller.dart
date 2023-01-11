import 'package:contatos/controllers/interface/i_base_controller.dart';
import 'package:contatos/models/dto/endereco_dto.dart';
import 'package:contatos/models/entities/endereco_entity.dart';

abstract class IContatoController implements IBaseController {
  String get id;
  String get nome;
  String get cpf;
  String get telefone;
  EnderecoEntity? get endereco;

  void defineId(String id);

  void defineNome(String nome);

  void defineCpf(String cpf);

  void defineTelefone(String telefone);

  void defineEndereco(EnderecoEntity? endereco);

  String? nomeEhValido(String? nome);

  String? cpfEhValido(String? cpf);

  String? telefoneEhValido(String? telefone);

  Future<void> salvar();

  Future<void> buscarPorId(String id);

  Future<void> buscarPorCep(String cep);

  Future<List<EnderecoDto>> buscarPorPesquisa(
    String uf,
    String cidade,
    String logradouro,
  );

  Future<void> selecionaEndereco(EnderecoDto endereco);
}
