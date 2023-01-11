import 'package:contatos/controllers/implementation/base_controller.dart';
import 'package:contatos/controllers/interface/i_usuario_controller.dart';
import 'package:contatos/models/entities/usuario_entity.dart';
import 'package:contatos/models/states/carregando_state.dart';
import 'package:contatos/models/states/erro_state.dart';
import 'package:contatos/models/states/interface/i_base_state.dart';
import 'package:contatos/models/states/sucesso_state.dart';
import 'package:contatos/repositories/implementation/usuario_repository.dart';
import 'package:contatos/utils/excecoes_util.dart';

class UsuarioController extends BaseController implements IUsuarioController {
  final UsuarioRepository repositorio;

  @override
  String email = "";

  @override
  String senha = "";

  UsuarioController(this.repositorio);

  @override
  Future<void> excluirMinhaConta() {
    alteraEstado(CarregandoState());

    return repositorio
        .remover("id")
        .then<IBaseState>((removeu) => SucessoState(null))
        .catchError((e) {
      return ErroState("Não foi possível excluir a conta!");
    });
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> login() {
    alteraEstado(CarregandoState());

    return repositorio.login(email, senha).then((logou) {
      if (logou) {
        return SucessoState(null);
      } else {
        return ErroState("Usuário ou senha inválidos!");
      }
    }).then(alteraEstado);
  }

  @override
  Future<void> criarConta() {
    alteraEstado(CarregandoState());

    return repositorio
        .criar(UsuarioEntity(id: "", login: email, senha: senha))
        .then<IBaseState>((usuario) => SucessoState(usuario))
        .catchError((e) {
      if (e is ConflitoExcecao) {
        return ErroState(e.mensagem!);
      }

      throw e;
    }).then(alteraEstado);
  }

  @override
  void defineEmail(String email) {
    this.email = email;
  }

  @override
  void defineSenha(String senha) {
    this.senha = senha;
  }

  @override
  String? emailEhValido(String? email) {
    if (email == null) return null;

    const mensagemErro = "Informe um e-mail válido!";

    if (email.isEmpty) return mensagemErro;

    if (!email.contains("@")) return mensagemErro;

    if (!email.substring(email.indexOf("@")).contains(".com")) {
      return mensagemErro;
    }

    return null;
  }

  @override
  String? senhaEhValida(String? senha) {
    if (senha == null) return null;

    const mensagemErro = "Senha deve conter no mínimo 6 dígitos!";

    if (senha.isEmpty) return mensagemErro;

    if (senha.length < 6) return mensagemErro;

    return null;
  }
}
