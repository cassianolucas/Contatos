import 'package:contatos/models/states/interface/i_base_state.dart';
import 'package:flutter/cupertino.dart';

abstract class IBaseController extends ValueNotifier<IBaseState> {
  IBaseController(super.value);

  void alteraEstado(IBaseState estado);
}
