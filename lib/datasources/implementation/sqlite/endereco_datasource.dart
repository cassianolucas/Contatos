import 'package:contatos/datasources/implementation/sqlite/base_datasource.dart';
import 'package:contatos/datasources/interface/i_endereco_datasource.dart';
import 'package:contatos/mappers/implementation/endereco_mapper.dart';
import 'package:contatos/models/entities/endereco_entity.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:sqflite/sqflite.dart';

class EnderecoDataSource extends BaseDataSource<EnderecoEntity>
    implements IEnderecoDataSource {
  EnderecoDataSource(Database database)
      : super(
          SqliteUtil.tabelaEndereco,
          EnderecoMapper(),
          database,
        );
}
