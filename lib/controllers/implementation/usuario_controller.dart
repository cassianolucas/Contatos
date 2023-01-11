import 'package:contatos/controllers/implementation/base_controller.dart';
import 'package:contatos/controllers/interface/i_usuario_controller.dart';
import 'package:contatos/models/entities/usuario_entity.dart';
import 'package:contatos/models/states/carregando_state.dart';
import 'package:contatos/models/states/erro_state.dart';
import 'package:contatos/models/states/inicial_state.dart';
import 'package:contatos/models/states/interface/i_base_state.dart';
import 'package:contatos/models/states/sucesso_state.dart';
import 'package:contatos/repositories/implementation/usuario_repository.dart';
import 'package:contatos/utils/criptografia_util.dart';
import 'package:contatos/utils/excecoes_util.dart';
import 'package:contatos/utils/usuario_util.dart';

class UsuarioController extends BaseController implements IUsuarioController {
  final UsuarioRepository _repositorio;

  @override
  String email = "";

  @override
  String senha = "";

  UsuarioController(this._repositorio);

  @override
  Future<void> excluirMinhaConta() {
    alteraEstado(CarregandoState());

    return _repositorio
        .remover(UsuarioUtil.I.usuarioLogado!.id)
        .then<IBaseState>((removeu) => SucessoState(null))
        .catchError((e) {
      return ErroState("Não foi possível excluir a conta!");
    }).then(alteraEstado);
  }

  @override
  Future<void> logOut() async {
    alteraEstado(CarregandoState());

    UsuarioUtil.I.usuarioLogado!.status = Status.deslogado;

    await _repositorio
        .alterar(UsuarioUtil.I.usuarioLogado!)
        .then((usuario) {
          UsuarioUtil.I.usuarioLogado = null;

          return usuario;
        })
        .then<IBaseState>((usuario) => SucessoState(usuario))
        .catchError((e) => ErroState("Não foi possível realizar o logout!"))
        .then(alteraEstado);
  }

  @override
  Future<void> login() {
    alteraEstado(CarregandoState());

    return _repositorio
        .login(email, CriptografiaUtil.criptografar(senha))
        .then<UsuarioEntity?>((logou) async {
      if (!logou) return null;

      var usuario = await _repositorio.buscarPorLogin(email);

      if (usuario != null) {
        usuario.status = Status.logado;
        await _repositorio.alterar(usuario);

        UsuarioUtil.I.usuarioLogado = usuario;
      }

      return usuario;
    }).then((usuario) {
      if (usuario != null) {
        return SucessoState(usuario);
      } else {
        return ErroState("Usuário ou senha inválidos!");
      }
    }).then(alteraEstado);
  }

  @override
  Future<void> criarConta() {
    alteraEstado(CarregandoState());

    return _repositorio
        .criar(UsuarioEntity(
          id: "",
          login: email,
          senha: CriptografiaUtil.criptografar(senha),
          status: Status.logado,
        ))
        .then((usuario) {
          UsuarioUtil.I.usuarioLogado = usuario;

          return usuario;
        })
        .then<IBaseState>((usuario) => SucessoState(usuario))
        .catchError((e) {
          if (e is ConflitoExcecao) {
            return ErroState(e.mensagem!);
          }

          throw e;
        })
        .then(alteraEstado);
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

  @override
  Future<void> estaLogado() async {
    alteraEstado(CarregandoState());

    var usuario = await _repositorio.buscarUsuarioLogado();

    if (usuario != null) {
      UsuarioUtil.I.usuarioLogado = usuario;

      alteraEstado(SucessoState(usuario));
    }

    alteraEstado(InicialState());
  }
}
