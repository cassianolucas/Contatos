import 'package:contatos/datasources/implementation/sqlite/base_datasource.dart';
import 'package:contatos/models/entities/usuario_entity.dart';

abstract class IUsuarioDataSource implements BaseDataSource<UsuarioEntity> {
  Future<UsuarioEntity?> buscarPorLogin(String login);
}
