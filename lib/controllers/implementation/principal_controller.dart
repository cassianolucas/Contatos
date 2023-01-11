import 'package:contatos/controllers/implementation/base_controller.dart';
import 'package:contatos/controllers/interface/i_principal_controller.dart';
import 'package:contatos/models/entities/contato_entity.dart';
import 'package:contatos/models/states/carregando_state.dart';
import 'package:contatos/models/states/erro_state.dart';
import 'package:contatos/models/states/interface/i_base_state.dart';
import 'package:contatos/models/states/sucesso_state.dart';
import 'package:contatos/repositories/interface/i_contato_repository.dart';
import 'package:contatos/utils/usuario_util.dart';

class PrincipalController extends BaseController
    implements IPrincipalController {
  final IContatoRepository _repositorio;

  final List<ContatoEntity> _contatos = [];

  int _pagina = 1;

  String _pesquisa = "";

  String _pesquisaAnterior = "";

  bool _finalizou = false;

  bool _proximaPagina = false;

  PrincipalController(this._repositorio);

  @override
  int get pagina => _pagina;

  @override
  String get pesquisa => _pesquisa;

  @override
  List<ContatoEntity> get contatos => List.unmodifiable(_contatos);

  @override
  Future<void> iniciar() async {
    _contatos.clear();
    _pesquisa = "";
    _pesquisaAnterior = "";
    _pagina = 1;
    _finalizou = false;
    _proximaPagina = false;

    await pesquisar();
  }

  @override
  Future<void> pesquisar() async {
    if (_pesquisaAnterior != pesquisa && !_proximaPagina) {
      _contatos.clear();
      _pagina = 1;
      _finalizou = false;
    }

    if (_finalizou) return;

    alteraEstado(CarregandoState());

    return _repositorio
        .buscarPorPesquisaEUsuario(
          pesquisa,
          UsuarioUtil.I.usuarioLogado!.id,
          limite: 10,
          pagina: pagina,
        )
        .then((contatos) {
          if (contatos.isEmpty) {
            _pagina--;
            _finalizou = true;
          }

          _contatos.addAll(contatos);

          return _contatos;
        })
        .then<IBaseState>((contatos) => SucessoState(contatos))
        .catchError((e) => ErroState("Oops falha na pesquisa!"))
        .then(alteraEstado);
  }

  @override
  Future<void> proximaPagina() async {
    _proximaPagina = true;
    _pagina++;

    await pesquisar();
  }

  @override
  void definePesquisa(String pesquisa) {
    _pesquisaAnterior = _pesquisa;
    _pesquisa = pesquisa;

    _proximaPagina = false;
  }

  @override
  Future<void> excluirContato(String id) async {
    alteraEstado(CarregandoState());

    return await _repositorio
        .remover(id)
        .then<IBaseState>((removeu) => SucessoState(null))
        .catchError((e) => ErroState("Não foi possível excluir o contato!"))
        .then(alteraEstado)
        .then((value) => iniciar());
  }
}
