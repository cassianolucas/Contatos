import 'package:contatos/presentation/screens/usuario/criar_conta_screen.dart';
import 'package:contatos/presentation/screens/usuario/login_screen.dart';
import 'package:contatos/presentation/screens/contato/contato_screen.dart';
import 'package:contatos/presentation/screens/principal/principal_screen.dart';
import 'package:flutter/material.dart';

class RoutesUtil {
  RoutesUtil._();

  static String get login => "/login";

  static String get criarConta => "/criarConta";

  static String get principal => "/principal";

  static String get contato => "/contato";

  static Map<String, WidgetBuilder> get rotas => {
        login: (context) => const LoginScreen(),
        criarConta: (context) => const CriarContaScreen(),
        principal: (context) => const PrincipalScreen(),
        contato: (context) => const ContatoScreen(),
      };
}
