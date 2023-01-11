extension StringHelper on String {
  List<String> toCharArray() {
    return runes.map((code) => String.fromCharCode(code)).toList();
  }

  bool get isNumeric => double.tryParse(this) != null;
}
