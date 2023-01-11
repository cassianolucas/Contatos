import 'package:contatos/datasources/implementation/sqlite/usuario_datasource.dart';
import 'package:contatos/models/entities/usuario_entity.dart';
import 'package:contatos/repositories/implementation/usuario_repository.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:contatos/utils/uuid_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqliteUtil.inicializar();

  var repositorio = UsuarioRepository(UsuarioDataSource(SqliteUtil.bancoDados));

  var usuario = UsuarioEntity(
    id: UuidUtil.generate(),
    login: "teste@teste.com.br",
    senha: "123456",
  );

  group("Usuário", () {
    test("Criar", () async {
      var entity = await repositorio.criar(usuario);

      expect(entity, isNotNull);
    });

    test("Alterar", () async {
      usuario.senha = "12345678";

      var entity = await repositorio.alterar(usuario);

      expect(entity, isNotNull);

      expect(entity.senha, equals(usuario.senha));
    });

    test("Buscar por id", () async {
      var entity = await repositorio.buscarPorId(usuario.id);

      expect(entity, isNotNull);
    });

    test("Login", () async {
      var logou = await repositorio.login(usuario.login, usuario.senha);

      expect(logou, isTrue);
    });

    test("Remover", () async {
      var removeu = await repositorio.remover(usuario.id);

      expect(removeu, isTrue);
    });
  });
}
