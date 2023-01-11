import 'package:contatos/models/entities/base_entity.dart';
import 'package:contatos/models/states/interface/i_base_state.dart';

class SucessoState<T> extends IBaseState {
  T valores;

  SucessoState(this.valores);
}
