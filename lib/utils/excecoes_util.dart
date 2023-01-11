class ConflitoExcecao implements Exception {
  String? mensagem;

  ConflitoExcecao({this.mensagem});
}

class FormatoInvalidoExcecao implements Exception {
  String? mensagem;

  FormatoInvalidoExcecao({this.mensagem});
}

class NenhumResultadoExcecao implements Exception {}
