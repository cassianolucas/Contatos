import 'package:contatos/models/states/interface/i_base_state.dart';

class SucessoState<T> extends IBaseState {
  T valores;

  SucessoState(this.valores);
}
