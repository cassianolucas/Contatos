import 'package:contatos/models/entities/base_entity.dart';

abstract class IBaseMapper<T extends BaseEntity> {
  T fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap(T entity);

  List<T> fromListMap(List<Map<String, dynamic>> maps);

  List<Map<String, dynamic>> toMaps(List<T> entities);
}
