import 'package:contatos/utils/routes_util.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqliteUtil.inicializar();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Aplicativo de teste",
    initialRoute: RoutesUtil.login,
    routes: RoutesUtil.rotas,
  ));
}
