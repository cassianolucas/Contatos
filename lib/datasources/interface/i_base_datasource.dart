import 'package:contatos/models/entities/base_entity.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class IBaseDataSource<T extends BaseEntity> {
  Future<T> insert(
    T entity, {
    Transaction? transacao,
  });

  Future<List<T>> select({
    String? condicao,
    List<Object>? parametros,
    int? limite,
    int? pagina,
    String? ordenar,
    Transaction? transacao,
  });

  Future<T> update(
    T entity,
    String condicao,
    List<Object>? parametros, {
    Transaction? transacao,
  });

  Future<bool> delete(
    String tabela,
    String condicao,
    List<Object>? parametros, {
    Transaction? transacao,
  });

  Future<T> criar(T entity);

  Future<T> alterar(T entity);

  Future<bool> remover(String id);

  Future<T> buscarPorId(String id);
}
