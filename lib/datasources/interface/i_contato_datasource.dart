import 'package:contatos/datasources/interface/i_base_datasource.dart';
import 'package:contatos/models/entities/contato_entity.dart';

abstract class IContatoDataSource implements IBaseDataSource<ContatoEntity> {
  Future<List<ContatoEntity>> buscarPorPesquisaUsuario(
    String pesquisa,
    String idUsuario, {
    int? limite,
    int? pagina,
  });
}
