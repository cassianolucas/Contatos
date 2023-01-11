import 'package:contatos/helpers/string_helper.dart';
import 'package:contatos/mappers/implementation/base_mapper.dart';
import 'package:contatos/mappers/implementation/contato_mapper.dart';
import 'package:contatos/mappers/interface/i_contato_mapper.dart';
import 'package:contatos/mappers/interface/i_endereco_mapper.dart';
import 'package:contatos/models/entities/endereco_entity.dart';

class EnderecoMapper extends BaseMapper<EnderecoEntity>
    implements IEnderecoMapper {
  static const String _colunaId = "id";
  static const String _colunaCep = "cep";
  static const String _colunaLogradouro = "logradouro";
  static const String _colunaComplemento = "complemento";
  static const String _colunaBairro = "bairro";
  static const String _colunaLocalidade = "localidade";
  static const String _colunaUf = "uf";
  static const String _colunaLatitude = "latitude";
  static const String _colunaLongitude = "longitude";
  static const String _colunaIdContato = "idContato";
  static const String _colunaContato = "contato";

  late final IContatoMapper _contatoMapper;

  EnderecoMapper() {
    _contatoMapper = ContatoMapper();
  }

  @override
  EnderecoEntity fromMap(Map<String, dynamic> map) => EnderecoEntity(
        id: map[_colunaId],
        cep: map[_colunaCep],
        logradouro: map[_colunaLogradouro],
        complemento: map[_colunaComplemento],
        bairro: map[_colunaBairro],
        localidade: map[_colunaLocalidade],
        uf: map[_colunaUf],
        latitude: map[_colunaLatitude],
        longitude: map[_colunaLongitude],
        idContato: map[_colunaIdContato],
        contato: map.containsKey(_colunaContato)
            ? _contatoMapper.fromMap(map[_colunaContato])
            : null,
      );

  @override
  Map<String, dynamic> toMap(EnderecoEntity entity) => {
        _colunaId: entity.id,
        _colunaCep: entity.cep.somenteNumero(),
        _colunaLogradouro: entity.logradouro,
        _colunaComplemento: entity.complemento,
        _colunaBairro: entity.bairro,
        _colunaLocalidade: entity.localidade,
        _colunaUf: entity.uf,
        _colunaLatitude: entity.latitude,
        _colunaLongitude: entity.longitude,
        _colunaIdContato: entity.idContato,
        if (entity.contato != null)
          _colunaContato: _contatoMapper.toMap(entity.contato!),
      };
}
