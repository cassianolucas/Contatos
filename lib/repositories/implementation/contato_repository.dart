import 'package:contatos/datasources/interface/i_contato_datasource.dart';
import 'package:contatos/models/entities/contato_entity.dart';
import 'package:contatos/repositories/implementation/base_repository.dart';
import 'package:contatos/repositories/interface/i_contato_repository.dart';

class ContatoRepository
    extends BaseRepository<ContatoEntity, IContatoDataSource>
    implements IContatoRepository {
  ContatoRepository(super.dataSource);

  @override
  Future<List<ContatoEntity>> buscarPorPesquisaEUsuario(
    String pesquisa,
    String idUsuario, {
    int? limite,
    int? pagina,
  }) =>
      dataSource.buscarPorPesquisaUsuario(
        pesquisa,
        idUsuario,
        limite: limite,
        pagina: pagina,
      );
}
