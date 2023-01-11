import 'dart:math';

class UuidUtil {
  UuidUtil._();

  static String generate() {
    String resultado = "";

    List<String> letras = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "a",
      "b",
      "c",
      "d",
      "e",
      "f"
    ];

    List<int> posicoes = [8, 12, 16, 20];

    Random randomico = Random.secure();

    for (var i = 0; i < 32; i++) {
      var adicionaLetra = randomico.nextBool();

      if (posicoes.contains(i)) {
        resultado += "-";
      }

      if (i == 12) {
        resultado += "4";
        continue;
      }

      if (adicionaLetra) {
        var posicao = randomico.nextInt(letras.length);
        resultado += letras[posicao];
      } else {
        var numero = randomico.nextInt(9);
        resultado += "$numero";
      }
    }

    return resultado;
  }
}
