import 'package:contatos/datasources/interface/i_endereco_datasource.dart';
import 'package:contatos/models/entities/endereco_entity.dart';
import 'package:contatos/repositories/interface/i_base_repository.dart';

abstract class IEnderecoRepository
    implements IBaseRepository<EnderecoEntity, IEnderecoDataSource> {}
