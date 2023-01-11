import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteUtil {
  SqliteUtil._();

  static Database? _bancoDados;

  static Database get bancoDados => _bancoDados!;

  static const String nomeBanco = "contatos.db";

  static const String _tipoTextoNaoNulo = "text not null";

  static const String _tipoTexto = "text";

  static const String tabelaUsuario = "usuarios";

  static const String tabelaContato = "contatos";

  static const String tabelaEndereco = "enderecos";

  static Map<String, List<String>> _geraColunas() {
    Map<String, List<String>> colunas = {};

    for (var elemento in tabelas.entries) {
      colunas.addAll({elemento.key: elemento.value.keys.toList()});
    }

    return colunas;
  }

  static String _preparaColuna(MapEntry<String, String> coluna) {
    String campo = "${coluna.key} ${coluna.value}";

    if (coluna.key == "fk") {
      campo = " ${coluna.value}";
    }

    return campo;
  }

  static String _sqlCriaTabela(String tabela) {
    String campos = tabelas[tabela]!.entries.map(_preparaColuna).join(", ");

    return "create table $tabela ($campos)";
  }

  static Future<void> _quandoCriar(Database banco, int versao) async {
    for (var tabela in tabelas.keys) {
      String sql = _sqlCriaTabela(tabela);

      await banco.execute(sql);
    }
  }

  static Future<void> inicializar() async {
    if (_bancoDados != null && _bancoDados!.isOpen) return;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();

      _bancoDados = await databaseFactoryFfi.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _quandoCriar,
          singleInstance: true,
        ),
      );
    } else {
      var diretorio = await getDatabasesPath();

      _bancoDados = await openDatabase(
        "$diretorio$nomeBanco",
        version: 1,
        onCreate: _quandoCriar,
        singleInstance: true,
      );
    }
  }

  static Map<String, Map<String, String>> get tabelas => {
        tabelaUsuario: _estruturaUsuario,
        tabelaContato: _estruturaContato,
        tabelaEndereco: _estrututaEndereco,
      };

  static Map<String, List<String>> get colunas => _geraColunas();

  static Map<String, String> get _estruturaUsuario => {
        "id": "$_tipoTextoNaoNulo primary key",
        "login": "$_tipoTextoNaoNulo unique",
        "senha": _tipoTextoNaoNulo,
      };

  static Map<String, String> get _estruturaContato => {
        "id": "$_tipoTextoNaoNulo primary key",
        "nome": _tipoTextoNaoNulo,
        "cpf": "$_tipoTextoNaoNulo unique",
        "telefone": _tipoTextoNaoNulo,
        "idUsuario": _tipoTextoNaoNulo,
        "fk":
            "foreign key (idUsuario) references $tabelaUsuario (id) on delete cascade",
      };

  static Map<String, String> get _estrututaEndereco => {
        "id": "$_tipoTextoNaoNulo primary key",
        "cep": _tipoTextoNaoNulo,
        "logradouro": _tipoTextoNaoNulo,
        "complemento": _tipoTexto,
        "bairro": _tipoTextoNaoNulo,
        "localidade": _tipoTextoNaoNulo,
        "uf": _tipoTextoNaoNulo,
        "latitude": _tipoTextoNaoNulo,
        "longitude": _tipoTextoNaoNulo,
        "idContato": _tipoTextoNaoNulo,
        "fk":
            "foreign key (idContato) references $tabelaContato (id) on delete cascade",
      };
}
