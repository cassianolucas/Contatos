import 'package:contatos/datasources/interface/i_base_datasource.dart';
import 'package:contatos/models/entities/base_entity.dart';

abstract class IBaseRepository<T extends BaseEntity,
    G extends IBaseDataSource<T>> {
  final G dataSource;

  IBaseRepository(this.dataSource);

  Future<T> criar(T entity);

  Future<T> alterar(T entity);

  Future<bool> remover(String id);

  Future<T> buscarPorId(String id);
}
