import 'package:contatos/mappers/interface/i_base_mapper.dart';
import 'package:contatos/models/entities/base_entity.dart';

class BaseMapper<T extends BaseEntity> implements IBaseMapper<T> {
  @override
  List<T> fromListMap(List<Map<String, dynamic>> maps) =>
      maps.map(fromMap).toList();

  @override
  T fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toMap(T entity) {
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>> toMaps(List<T> entities) =>
      entities.map(toMap).toList();
}
