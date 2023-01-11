import 'package:contatos/datasources/interface/i_usuario_datasource.dart';
import 'package:contatos/models/entities/usuario_entity.dart';
import 'package:contatos/repositories/implementation/base_repository.dart';
import 'package:contatos/repositories/interface/i_usuario_repository.dart';

class UsuarioRepository
    extends BaseRepository<UsuarioEntity, IUsuarioDataSource>
    implements IUsuarioRepository {
  UsuarioRepository(super.dataSource);

  @override
  Future<bool> login(String login, String senha) async {
    var usuario = await buscarPorLogin(login);

    if (usuario?.senha == senha) {
      return true;
    }

    return false;
  }

  @override
  Future<UsuarioEntity?> buscarPorLogin(String login) =>
      dataSource.buscarPorLogin(login);

  @override
  Future<UsuarioEntity?> buscarUsuarioLogado() =>
      dataSource.buscarUsuarioLogado();
}
