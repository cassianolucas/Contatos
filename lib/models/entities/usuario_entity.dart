import 'package:contatos/models/entities/base_entity.dart';

enum Status {
  logado,
  deslogado,
}

class UsuarioEntity extends BaseEntity {
  late String login;
  late String senha;
  late Status status;

  UsuarioEntity({
    required super.id,
    required this.login,
    required this.senha,
    this.status = Status.deslogado,
  });
}
