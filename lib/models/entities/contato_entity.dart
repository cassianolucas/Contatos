import 'package:contatos/models/entities/base_entity.dart';
import 'package:contatos/models/entities/endereco_entity.dart';
import 'package:contatos/models/entities/usuario_entity.dart';

class ContatoEntity extends BaseEntity {
  late String nome;
  late String cpf;
  late String telefone;
  late String idUsuario;
  UsuarioEntity? usuario;
  EnderecoEntity? endereco;

  ContatoEntity({
    required super.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.idUsuario,
    this.usuario,
    this.endereco,
  });
}
