import 'package:contatos/datasources/interface/i_usuario_datasource.dart';
import 'package:contatos/models/entities/usuario_entity.dart';
import 'package:contatos/repositories/interface/i_base_repository.dart';

abstract class IUsuarioRepository
    implements IBaseRepository<UsuarioEntity, IUsuarioDataSource> {
  Future<bool> login(String login, String senha);

  Future<UsuarioEntity?> buscarPorLogin(String login);

  Future<UsuarioEntity?> buscarUsuarioLogado();
}
