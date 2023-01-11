import 'package:brasil_fields/brasil_fields.dart';
import 'package:contatos/controllers/implementation/base_controller.dart';
import 'package:contatos/controllers/interface/i_contato_controller.dart';
import 'package:contatos/helpers/string_helper.dart';
import 'package:contatos/models/dto/endereco_dto.dart';
import 'package:contatos/models/entities/contato_entity.dart';
import 'package:contatos/models/entities/endereco_entity.dart';
import 'package:contatos/models/states/carregando_state.dart';
import 'package:contatos/models/states/erro_state.dart';
import 'package:contatos/models/states/inicial_state.dart';
import 'package:contatos/models/states/interface/i_base_state.dart';
import 'package:contatos/models/states/sucesso_state.dart';
import 'package:contatos/repositories/interface/i_contato_repository.dart';
import 'package:contatos/services/interface/i_viacep_service.dart';
import 'package:contatos/utils/endereco_util.dart';
import 'package:contatos/utils/excecoes_util.dart';
import 'package:contatos/utils/usuario_util.dart';
import 'package:sqflite/sqflite.dart';

class ContatoController extends BaseController implements IContatoController {
  final IContatoRepository _repositorio;
  final IViaCepService _viaCepService;

  String _id = "";

  String _nome = "";

  String _cpf = "";

  String _telefone = "";

  EnderecoEntity? _endereco;

  ContatoController(this._repositorio, this._viaCepService);

  @override
  String get id => _id;

  @override
  String get nome => _nome;

  @override
  String get cpf => _cpf.isEmpty ? _cpf : UtilBrasilFields.obterCpf(_cpf);

  @override
  String get telefone =>
      _telefone.isEmpty ? _telefone : UtilBrasilFields.obterTelefone(_telefone);

  @override
  EnderecoEntity? get endereco => _endereco;

  @override
  void defineId(String id) => _id = id;

  @override
  void defineNome(String nome) => _nome = nome;

  @override
  void defineCpf(String cpf) => _cpf = cpf.somenteNumero();

  @override
  void defineTelefone(String telefone) => _telefone = telefone.somenteNumero();

  @override
  void defineEndereco(EnderecoEntity? endereco) {
    _endereco = endereco;

    notifyListeners();
  }

  @override
  String? cpfEhValido(String? cpf) {
    if (!CPFValidator.isValid(cpf)) {
      return "Informe um cpf válido!";
    }

    return null;
  }

  @override
  String? nomeEhValido(String? nome) {
    if (nome == null) return null;

    if (nome.isEmpty) {
      return "Informe um nome válido!";
    }

    return null;
  }

  @override
  String? telefoneEhValido(String? telefone) {
    if (telefone == null) return null;

    const String mensagemErro = "Informe um telefone válido!";

    if (telefone.isEmpty) return mensagemErro;

    if (telefone.somenteNumero().length != 10 &&
        telefone.somenteNumero().length != 11) {
      return mensagemErro;
    }

    return null;
  }

  IBaseState _trataErro(e) {
    if (e is FormatoInvalidoExcecao) {
      alteraEstado(ErroState(e.mensagem!));
    }

    if (e is NenhumResultadoExcecao) {
      return ErroState("Nenhum resultado!");
    }

    if (e is ConflitoExcecao) {
      return ErroState(e.mensagem!);
    }

    if (e is DatabaseException) {
      return ErroState(e.toString());
    }

    throw e;
  }

  @override
  Future<void> salvar() async {
    alteraEstado(CarregandoState());

    Future executor;

    if (id.isEmpty) {
      executor = _repositorio.criar(
        ContatoEntity(
          id: "",
          nome: nome,
          cpf: cpf,
          telefone: telefone,
          idUsuario: UsuarioUtil.I.usuarioLogado!.id,
          endereco: endereco,
        ),
      );
    } else {
      executor = _repositorio.alterar(
        ContatoEntity(
          id: id,
          nome: nome,
          cpf: cpf,
          telefone: telefone,
          idUsuario: UsuarioUtil.I.usuarioLogado!.id,
          endereco: endereco,
        ),
      );
    }

    return executor
        .then<IBaseState>((contato) => SucessoState(contato))
        .catchError(_trataErro)
        .then(alteraEstado);
  }

  @override
  Future<void> buscarPorId(String id) async {
    alteraEstado(CarregandoState());

    await Future.delayed(const Duration(milliseconds: 100));

    return await _repositorio
        .buscarPorId(id)
        .then((contato) {
          defineId(contato.id);
          defineNome(contato.nome);
          defineCpf(contato.cpf);
          defineTelefone(contato.telefone);
          defineEndereco(contato.endereco);

          return contato;
        })
        .then<IBaseState>((contato) => InicialState())
        .catchError(_trataErro)
        .then(alteraEstado);
  }

  @override
  Future<void> buscarPorCep(String cep) async {
    alteraEstado(CarregandoState());

    var endereco = await _viaCepService
        .buscarPorCep(cep)
        .then<EnderecoDto?>((endereco) => endereco)
        // ignore: invalid_return_type_for_catch_error
        .catchError(_trataErro);

    if (endereco == null) return;

    selecionaEndereco(endereco);

    alteraEstado(SucessoState(endereco));
  }

  @override
  Future<List<EnderecoDto>> buscarPorPesquisa(
    String uf,
    String cidade,
    String logradouro,
  ) {
    alteraEstado(CarregandoState());

    return _viaCepService
        .buscarPorPesquisa(uf, cidade, logradouro)
        .then((enderecos) {
      alteraEstado(SucessoState(null));
      return enderecos;
    }).catchError((e) {
      if (e is FormatoInvalidoExcecao) {
        alteraEstado(ErroState(e.mensagem!));
      }

      return <EnderecoDto>[];
    });
  }

  @override
  Future<void> selecionaEndereco(EnderecoDto endereco) async {
    var coordenadas = await EnderecoUtil.buscarCoordenadasPorEndereco(
      endereco.toString(),
    );

    defineEndereco(
      EnderecoEntity(
        id: "",
        cep: endereco.cep,
        logradouro: endereco.logradouro,
        bairro: endereco.bairro,
        localidade: endereco.localidade,
        uf: endereco.uf,
        latitude: coordenadas.latitude,
        longitude: coordenadas.longitude,
        idContato: "",
      ),
    );
  }
}
