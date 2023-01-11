import 'package:contatos/models/entities/base_entity.dart';
import 'package:contatos/models/entities/contato_entity.dart';

class EnderecoEntity extends BaseEntity {
  late String cep;
  late String logradouro;
  String? complemento;
  late String bairro;
  late String localidade;
  late String uf;
  late String latitude;
  late String longitude;
  late String idContato;
  ContatoEntity? contato;

  EnderecoEntity({
    required super.id,
    required this.cep,
    required this.logradouro,
    this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.latitude,
    required this.longitude,
    required this.idContato,
    this.contato,
  });
}
