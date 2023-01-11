import 'package:contatos/datasources/implementation/sqlite/base_datasource.dart';
import 'package:contatos/datasources/interface/i_usuario_datasource.dart';
import 'package:contatos/mappers/implementation/usuario_mapper.dart';
import 'package:contatos/models/entities/usuario_entity.dart';
import 'package:contatos/utils/excecoes_util.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDataSource extends BaseDataSource<UsuarioEntity>
    implements IUsuarioDataSource {
  UsuarioDataSource(
    Database dataBase,
  ) : super(
          SqliteUtil.tabelaUsuario,
          UsuarioMapper(),
          dataBase,
        );

  @override
  Future<UsuarioEntity> criar(UsuarioEntity entity) async {
    var usuarioDb = await buscarPorLogin(entity.login);

    if (usuarioDb != null) {
      throw ConflitoExcecao(mensagem: "Usuário existente!");
    }

    return super.criar(entity);
  }

  @override
  Future<bool> remover(String id) async {
    return await transacao((transacao) async {
      await delete(
        SqliteUtil.tabelaContato,
        "idUsuario = ?",
        [id],
        transacao: transacao,
      );

      return await delete(
        SqliteUtil.tabelaUsuario,
        "id = ?",
        [id],
        transacao: transacao,
      );
    });
  }

  @override
  Future<UsuarioEntity?> buscarPorLogin(String login) async {
    var resultados = await select(
      condicao: "login = ?",
      parametros: [login],
    );

    if (resultados.isEmpty) {
      return null;
    }

    return resultados.first;
  }

  @override
  Future<UsuarioEntity?> buscarUsuarioLogado() async {
    var usuarios = await select(
      condicao: "status = ?",
      parametros: [Status.logado.index],
    );

    if (usuarios.isEmpty) return null;

    return usuarios.first;
  }
}
