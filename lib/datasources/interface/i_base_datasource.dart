import 'package:contatos/models/entities/base_entity.dart';

abstract class IBaseDataSource<T extends BaseEntity> {
  Future<T> criar(T entity);

  Future<T> alterar(T entity);

  Future<bool> remover(String id);

  Future<T> buscarPorId(String id);
}
