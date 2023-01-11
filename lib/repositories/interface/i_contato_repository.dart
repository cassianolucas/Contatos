import 'package:contatos/datasources/interface/i_contato_datasource.dart';
import 'package:contatos/models/entities/contato_entity.dart';
import 'package:contatos/repositories/interface/i_base_repository.dart';

abstract class IContatoRepository
    implements IBaseRepository<ContatoEntity, IContatoDataSource> {
  Future<List<ContatoEntity>> buscarPorPesquisaEUsuario(
    String pesquisa,
    String idUsuario, {
    int? limite,
    int? pagina,
  });
}
