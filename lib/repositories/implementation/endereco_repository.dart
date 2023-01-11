import 'package:contatos/datasources/interface/i_endereco_datasource.dart';
import 'package:contatos/models/entities/endereco_entity.dart';
import 'package:contatos/repositories/implementation/base_repository.dart';
import 'package:contatos/repositories/interface/i_endereco_repository.dart';

class EnderecoRepository
    extends BaseRepository<EnderecoEntity, IEnderecoDataSource>
    implements IEnderecoRepository {
  EnderecoRepository(super.dataSource);
}
