import 'package:contatos/datasources/implementation/sqlite/base_datasource.dart';
import 'package:contatos/datasources/implementation/sqlite/endereco_datasource.dart';
import 'package:contatos/datasources/interface/i_contato_datasource.dart';
import 'package:contatos/datasources/interface/i_endereco_datasource.dart';
import 'package:contatos/helpers/string_helper.dart';
import 'package:contatos/mappers/implementation/contato_mapper.dart';
import 'package:contatos/models/entities/contato_entity.dart';
import 'package:contatos/utils/excecoes_util.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:sqflite/sqflite.dart';

class ContatoDataSource extends BaseDataSource<ContatoEntity>
    implements IContatoDataSource {
  late final IEnderecoDataSource _enderecoDataSource;

  ContatoDataSource(Database database)
      : super(
          SqliteUtil.tabelaContato,
          ContatoMapper(),
          database,
        ) {
    _enderecoDataSource = EnderecoDataSource(database);
  }

  @override
  Future<ContatoEntity> criar(ContatoEntity entity) async {
    var contato = await buscarPorCpf(entity.cpf);

    return transacao((transacao) async {
      if (contato != null) {
        throw ConflitoExcecao(mensagem: "Contato existente!");
      }

      var contatoDb = await insert(entity, transacao: transacao);

      contatoDb.endereco!.idContato = contatoDb.id;

      await _enderecoDataSource.insert(entity.endereco!, transacao: transacao);

      return contatoDb;
    });
  }

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
  }) async {
    var contatos = await select(
      condicao:
          "idUsuario = ? and ((nome like '%'||?||'%') or (cpf like '%'||?||'%') or (? = ''))",
      parametros: [idUsuario, pesquisa, pesquisa, pesquisa],
      limite: limite,
      pagina: pagina,
      ordenar: "nome asc",
    );

    for (var contato in contatos) {
      var endereco = await _enderecoDataSource.buscarPorContato(contato.id);
      contato.endereco = endereco;
    }

    return contatos;
  }

  @override
  Future<ContatoEntity> buscarPorId(String id) async {
    var contato = await super.buscarPorId(id);

    var endereco = await _enderecoDataSource.buscarPorContato(contato.id);

    contato.endereco = endereco;

    return contato;
  }

  @override
  Future<ContatoEntity?> buscarPorCpf(String cpf) async {
    var contatos = await select(
      condicao: "cpf = ?",
      parametros: [cpf.somenteNumero()],
    );

    if (contatos.isEmpty) return null;

    return contatos.first;
  }
}
