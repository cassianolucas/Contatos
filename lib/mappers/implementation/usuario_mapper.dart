import 'package:contatos/mappers/implementation/base_mapper.dart';
import 'package:contatos/mappers/interface/i_usuario_mapper.dart';
import 'package:contatos/models/entities/usuario_entity.dart';

class UsuarioMapper extends BaseMapper<UsuarioEntity>
    implements IUsuarioMapper {
  static const String _colunaId = "id";
  static const String _colunaLogin = "login";
  static const String _colunaSenha = "senha";
  static const String _colunaStatus = "status";

  @override
  UsuarioEntity fromMap(Map<String, dynamic> map) => UsuarioEntity(
        id: map[_colunaId],
        login: map[_colunaLogin],
        senha: map[_colunaSenha],
        status: Status.values[map[_colunaStatus]],
      );

  @override
  Map<String, dynamic> toMap(UsuarioEntity entity) => {
        _colunaId: entity.id,
        _colunaLogin: entity.login,
        _colunaSenha: entity.senha,
        _colunaStatus: entity.status.index,
      };
}
