import 'package:contatos/models/entities/base_entity.dart';

class UsuarioEntity extends BaseEntity {
  late String login;
  late String senha;

  UsuarioEntity({
    required super.id,
    required this.login,
    required this.senha,
  });
}
