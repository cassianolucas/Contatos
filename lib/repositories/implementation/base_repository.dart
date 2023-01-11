import 'package:contatos/datasources/interface/i_base_datasource.dart';
import 'package:contatos/models/entities/base_entity.dart';
import 'package:contatos/repositories/interface/i_base_repository.dart';

class BaseRepository<T extends BaseEntity, G extends IBaseDataSource<T>>
    implements IBaseRepository<T, G> {
  final G _dataSource;

  BaseRepository(this._dataSource);

  @override
  G get dataSource => _dataSource;

  @override
  Future<T> criar(T entity) => dataSource.criar(entity);

  @override
  Future<T> alterar(T entity) => dataSource.alterar(entity);

  @override
  Future<bool> remover(String id) => dataSource.remover(id);

  @override
  Future<T> buscarPorId(String id) => dataSource.buscarPorId(id);
}
