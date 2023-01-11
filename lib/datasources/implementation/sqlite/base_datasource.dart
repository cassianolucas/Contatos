import 'package:contatos/datasources/interface/i_base_datasource.dart';
import 'package:contatos/mappers/interface/i_base_mapper.dart';
import 'package:contatos/models/entities/base_entity.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:contatos/utils/uuid_util.dart';
import 'package:sqflite/sqflite.dart';

class BaseDataSource<T extends BaseEntity> implements IBaseDataSource<T> {
  final IBaseMapper<T> _mapper;
  final Database database;
  final String tabela;

  IBaseMapper<T> get mapper => _mapper;

  BaseDataSource(
    this.tabela,
    this._mapper,
    this.database,
  );

  Map<String, dynamic> _converteParaEstrutura(T entity) {
    // gera id quando não existir
    if (entity.id.isEmpty) entity.id = UuidUtil.generate();

    var map = _mapper.toMap(entity);

    Map<String, dynamic> mapDb = {};

    for (var elemento in map.entries) {
      if (SqliteUtil.colunas[tabela]!.contains(elemento.key)) {
        mapDb.addAll({elemento.key: elemento.value});
      }
    }

    return mapDb;
  }

  @override
  Future<List<T>> select({
    String? condicao,
    List<Object>? parametros,
    int? limite,
    int? pagina,
    String? ordenar,
    Transaction? transacao,
  }) {
    assert(limite == null || limite > 0, "Limite deve ser maior que 0");
    assert(pagina == null || pagina >= 1, "página deve ser maior que 1");

    pagina ??= 1;
    limite ??= 20;

    int pular = pagina > 1 ? pagina * limite : 0;

    var colunas = SqliteUtil.colunas[tabela]!;

    colunas.removeWhere((elemento) => elemento == "fk");

    var executor = transacao ?? database;

    return executor
        .query(
          tabela,
          columns: colunas,
          where: condicao,
          whereArgs: parametros,
          limit: limite,
          offset: pular,
          orderBy: ordenar,
        )
        .then(mapper.fromListMap);
  }

  @override
  Future<T> insert(
    T entity, {
    Transaction? transacao,
  }) {
    var executor = transacao ?? database;

    return executor
        .insert(
          tabela,
          _converteParaEstrutura(entity),
          conflictAlgorithm: ConflictAlgorithm.abort,
        )
        .then((value) => entity);
  }

  @override
  Future<T> update(
    T entity,
    String condicao,
    List<Object>? parametros, {
    Transaction? transacao,
  }) {
    var executor = transacao ?? database;

    return executor
        .update(
          tabela,
          _converteParaEstrutura(entity),
          where: condicao,
          whereArgs: parametros,
          conflictAlgorithm: ConflictAlgorithm.abort,
        )
        .then((value) => entity);
  }

  @override
  Future<bool> delete(
    String tabela,
    String condicao,
    List<Object>? parametros, {
    Transaction? transacao,
  }) {
    var executor = transacao ?? database;

    return executor
        .delete(
          tabela,
          where: condicao,
          whereArgs: parametros,
        )
        .then((value) => value >= 1);
  }

  Future<R> transacao<R>(Future<R> Function(Transaction) executar) =>
      database.transaction(executar);

  @override
  Future<T> criar(T entity) => insert(entity);

  @override
  Future<T> alterar(T entity) => update(
        entity,
        "id = ?",
        [entity.id],
      );

  @override
  Future<T> buscarPorId(String id) async {
    var resultados = await select(
      condicao: "id = ?",
      limite: 1,
      parametros: [id],
    );

    return resultados.first;
  }

  @override
  Future<bool> remover(String id) => delete(tabela, "id = ?", [id]);
}
