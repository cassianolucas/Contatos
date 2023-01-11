import 'package:contatos/controllers/implementation/base_controller.dart';
import 'package:contatos/models/entities/contato_entity.dart';

abstract class IPrincipalController extends BaseController {
  List<ContatoEntity> get contatos;

  int get pagina;

  String get pesquisa;

  void definePesquisa(String pesquisa);

  Future<void> pesquisar();

  Future<void> proximaPagina();

  Future<void> iniciar();

  Future<void> excluirContato(String id);
}
