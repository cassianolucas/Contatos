import 'package:contatos/models/states/interface/i_base_state.dart';

class ErroState extends IBaseState {
  final String mensagem;

  ErroState(this.mensagem);
}
