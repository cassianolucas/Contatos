import 'package:contatos/datasources/implementation/sqlite/contato_datasource.dart';
import 'package:contatos/datasources/implementation/sqlite/usuario_datasource.dart';
import 'package:contatos/models/entities/contato_entity.dart';
import 'package:contatos/models/entities/usuario_entity.dart';
import 'package:contatos/repositories/implementation/contato_repository.dart';
import 'package:contatos/repositories/implementation/usuario_repository.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:contatos/utils/uuid_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqliteUtil.inicializar();

  var repositorio = ContatoRepository(
    ContatoDataSource(SqliteUtil.bancoDados),
  );

  var repositorioUsuario = UsuarioRepository(
    UsuarioDataSource(SqliteUtil.bancoDados),
  );

  var usuario = UsuarioEntity(
    id: UuidUtil.generate(),
    login: "teste@teste.com.br",
    senha: "qwerty",
  );

  var contato = ContatoEntity(
    id: UuidUtil.generate(),
    nome: "contato",
    cpf: "00000000000",
    telefone: "00000000000",
    idUsuario: usuario.id,
  );

  group("Contato", () {
    test("Criar", () async {
      var temp = await repositorioUsuario.criar(usuario);

      expect(temp, isNotNull);

      contato = await repositorio.criar(contato);

      expect(contato, isNotNull);
    });

    test("Alterar", () async {
      contato.nome = "contato1";

      contato = await repositorio.alterar(contato);

      expect(contato.nome, equals("contato1"));
    });

    test("Buscar por id", () async {
      var temp = await repositorio.buscarPorId(contato.id);

      expect(temp, isNotNull);
    });

    test("Buscar por pesquisa \"contato\" e id de usuário", () async {
      var contatos = await repositorio.buscarPorPesquisaEUsuario(
        "contato",
        usuario.id,
      );

      expect(contatos.length, equals(1));
    });

    test("Buscar por pesquisa \"vazia\" e id de usuário", () async {
      var contatos = await repositorio.buscarPorPesquisaEUsuario(
        "",
        usuario.id,
      );

      expect(contatos.length, equals(1));
    });

    test("Remover", () async {
      var removeu = await repositorio.remover(contato.id);

      expect(removeu, isTrue);
    });
  });
}
