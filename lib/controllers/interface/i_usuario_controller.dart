import 'package:contatos/controllers/interface/i_base_controller.dart';

abstract class IUsuarioController implements IBaseController {
  String get email;
  String get senha;

  void defineEmail(String email);

  void defineSenha(String senha);

  String? emailEhValido(String? email);

  String? senhaEhValida(String? senha);

  Future<void> criarConta();

  Future<void> login();

  Future<void> logOut();

  Future<void> excluirMinhaConta();

  Future<void> estaLogado();
}
