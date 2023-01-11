import 'package:contatos/controllers/interface/i_base_controller.dart';
import 'package:contatos/models/states/inicial_state.dart';
import 'package:contatos/models/states/interface/i_base_state.dart';
import 'package:flutter/cupertino.dart';

class BaseController extends ValueNotifier<IBaseState>
    implements IBaseController {
  BaseController() : super(InicialState());

  @override
  void alteraEstado(IBaseState estado) => value = estado;
}
