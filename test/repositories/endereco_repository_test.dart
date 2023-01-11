import 'package:contatos/datasources/implementation/sqlite/contato_datasource.dart';
import 'package:contatos/datasources/implementation/sqlite/endereco_datasource.dart';
import 'package:contatos/datasources/implementation/sqlite/usuario_datasource.dart';
import 'package:contatos/models/entities/contato_entity.dart';
import 'package:contatos/models/entities/endereco_entity.dart';
import 'package:contatos/models/entities/usuario_entity.dart';
import 'package:contatos/repositories/implementation/contato_repository.dart';
import 'package:contatos/repositories/implementation/endereco_repository.dart';
import 'package:contatos/repositories/implementation/usuario_repository.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:contatos/utils/uuid_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqliteUtil.inicializar();

  var repositorioContato = ContatoRepository(
    ContatoDataSource(SqliteUtil.bancoDados),
  );

  var repositorioUsuario = UsuarioRepository(
    UsuarioDataSource(SqliteUtil.bancoDados),
  );

  var repositorio =
      EnderecoRepository(EnderecoDataSource(SqliteUtil.bancoDados));

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

  var endereco = EnderecoEntity(
    id: UuidUtil.generate(),
    cep: "83606000",
    logradouro: "Avenida Ademar de Barros",
    bairro: "Jardim Social",
    localidade: "Campo Largo",
    uf: "PR",
    latitude: "-25.4391448",
    longitude: "-49.553144",
    idContato: contato.id,
  );

  group("Endereço", () {
    test("Criar", () async {
      usuario = await repositorioUsuario.criar(usuario);

      expect(usuario, isNotNull);

      contato = await repositorioContato.criar(contato);

      expect(contato, isNotNull);

      endereco = await repositorio.criar(endereco);

      expect(endereco, isNotNull);
    });

    test("Alterar", () async {
      endereco.bairro = "eita";

      endereco = await repositorio.alterar(endereco);

      expect(endereco.bairro, equals("eita"));
    });

    test("Buscar por id", () async {
      endereco = await repositorio.buscarPorId(endereco.id);

      expect(endereco, isNotNull);
    });

    test("Remover", () async {
      var removeu = await repositorio.remover(endereco.id);

      expect(removeu, isTrue);
    });
  });
}
