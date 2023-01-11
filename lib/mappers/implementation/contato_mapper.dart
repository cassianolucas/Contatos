import 'package:contatos/helpers/string_helper.dart';
import 'package:contatos/mappers/implementation/base_mapper.dart';
import 'package:contatos/mappers/implementation/usuario_mapper.dart';
import 'package:contatos/mappers/interface/i_contato_mapper.dart';
import 'package:contatos/mappers/interface/i_usuario_mapper.dart';
import 'package:contatos/models/entities/contato_entity.dart';

class ContatoMapper extends BaseMapper<ContatoEntity>
    implements IContatoMapper {
  static const String _colunaId = "id";
  static const String _colunaNome = "nome";
  static const String _colunaCpf = "cpf";
  static const String _colunaTelefone = "telefone";
  static const String _colunaIdUsuario = "idUsuario";
  static const String _colunaUsuario = "usuario";

  late final IUsuarioMapper _usuarioMapper;

  ContatoMapper() {
    _usuarioMapper = UsuarioMapper();
  }

  @override
  ContatoEntity fromMap(Map<String, dynamic> map) => ContatoEntity(
        id: map[_colunaId],
        nome: map[_colunaNome],
        cpf: map[_colunaCpf],
        telefone: map[_colunaTelefone],
        idUsuario: map[_colunaIdUsuario],
        usuario: map.containsKey(_colunaUsuario)
            ? _usuarioMapper.fromMap(map[_colunaUsuario])
            : null,
      );

  @override
  Map<String, dynamic> toMap(ContatoEntity entity) => {
        _colunaId: entity.id,
        _colunaNome: entity.nome,
        _colunaCpf: entity.cpf.somenteNumero(),
        _colunaTelefone: entity.telefone.somenteNumero(),
        _colunaIdUsuario: entity.idUsuario,
        if (entity.usuario != null)
          _colunaUsuario: _usuarioMapper.toMap(entity.usuario!),
      };
}
