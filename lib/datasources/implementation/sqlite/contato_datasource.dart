import 'package:contatos/datasources/implementation/sqlite/base_datasource.dart';
import 'package:contatos/datasources/interface/i_contato_datasource.dart';
import 'package:contatos/mappers/implementation/contato_mapper.dart';
import 'package:contatos/models/entities/contato_entity.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:sqflite/sqflite.dart';

class ContatoDataSource extends BaseDataSource<ContatoEntity>
    implements IContatoDataSource {
  ContatoDataSource(Database database)
      : super(
          SqliteUtil.tabelaContato,
          ContatoMapper(),
          database,
        );

  @override
  Future<bool> remover(String id) async {
    return await transacao((transacao) async {
      await delete(
        SqliteUtil.tabelaEndereco,
        "idContato = ?",
        [id],
        transacao: transacao,
      );

      return delete(
        SqliteUtil.tabelaContato,
        "id = ?",
        [id],
        transacao: transacao,
      );
    });
  }

  @override
  Future<List<ContatoEntity>> buscarPorPesquisaUsuario(
    String pesquisa,
    String idUsuario, {
    int? limite,
    int? pagina,
  }) =>
      select(
        condicao:
            "idUsuario = ? and ((nome like '%'||?||'%') or (cpf like '%'||?||'%') or (? = ''))",
        parametros: [idUsuario, pesquisa, pesquisa, pesquisa],
        limite: limite,
        pagina: pagina,
        ordenar: "nome asc",
      );
}
