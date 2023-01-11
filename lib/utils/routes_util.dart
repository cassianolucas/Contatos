import 'package:contatos/presentation/screens/criar_conta_screen.dart';
import 'package:contatos/presentation/screens/login_screen.dart';
import 'package:contatos/presentation/screens/principal_screen.dart';
import 'package:flutter/material.dart';

class RoutesUtil {
  RoutesUtil._();

  static String get login => "/login";

  static String get criarConta => "/criarConta";

  static String get principal => "/principal";

  static Map<String, WidgetBuilder> get rotas => {
        login: (context) => const LoginScreen(),
        criarConta: (context) => const CriarContaScreen(),
        principal: (context) => const PrincipalScreen(),
      };
}
