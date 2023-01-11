class EnderecoDto {
  late String cep;
  late String logradouro;
  String? complemento;
  late String bairro;
  late String localidade;
  late String uf;

  static const String _colunaCep = "cep";
  static const String _colunaLogradouro = "logradouro";
  static const String _colunaComplemento = "complemento";
  static const String _colunaBairro = "bairro";
  static const String _colunaLocalidade = "localidade";
  static const String _colunaUf = "uf";

  EnderecoDto({
    required this.cep,
    required this.logradouro,
    this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory EnderecoDto.fromMap(Map<String, dynamic> map) => EnderecoDto(
        cep: map[_colunaCep],
        logradouro: map[_colunaLogradouro],
        complemento: map[_colunaComplemento],
        bairro: map[_colunaBairro],
        localidade: map[_colunaLocalidade],
        uf: map[_colunaUf],
      );

  Map<String, dynamic> toMap() {
    return {
      _colunaCep: cep,
      _colunaLogradouro: logradouro,
      _colunaComplemento: complemento,
      _colunaBairro: bairro,
      _colunaLocalidade: localidade,
      _colunaUf: uf,
    };
  }

  @override
  String toString() => "$logradouro, $bairro, $localidade - $uf";
}
