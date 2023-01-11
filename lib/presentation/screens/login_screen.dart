import 'package:contatos/controllers/implementation/usuario_controller.dart';
import 'package:contatos/controllers/interface/i_usuario_controller.dart';
import 'package:contatos/datasources/implementation/sqlite/usuario_datasource.dart';
import 'package:contatos/models/states/carregando_state.dart';
import 'package:contatos/models/states/erro_state.dart';
import 'package:contatos/models/states/inicial_state.dart';
import 'package:contatos/models/states/sucesso_state.dart';
import 'package:contatos/presentation/components/botao_padrao.dart';
import 'package:contatos/presentation/components/campo_texto.dart';
import 'package:contatos/repositories/implementation/usuario_repository.dart';
import 'package:contatos/utils/routes_util.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final IUsuarioController _usuarioController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _usuarioController = UsuarioController(
      UsuarioRepository(UsuarioDataSource(SqliteUtil.bancoDados)),
    );

    _formKey = GlobalKey<FormState>();

    _usuarioController.addListener(() {
      if (_usuarioController.value is SucessoState) {
        Navigator.of(context).pushReplacementNamed(
          RoutesUtil.principal,
        );
      }
    });
  }

  @override
  void dispose() {
    _usuarioController.removeListener(() {});
    _usuarioController.dispose();

    super.dispose();
  }

  void _criarConta() {
    Navigator.of(context).pushReplacementNamed(RoutesUtil.criarConta);
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      await _usuarioController.login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .3,
          ),
          child: ValueListenableBuilder(
              valueListenable: _usuarioController,
              builder: (context, estado, child) {
                if (estado is CarregandoState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (estado is ErroState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(estado.mensagem),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                      ),
                      BotaoPadrao(
                        onTap: () {
                          _usuarioController.alteraEstado(InicialState());
                        },
                        text: "Tentar novamente",
                      ),
                    ],
                  );
                }

                if (estado is SucessoState) {
                  return Container();
                }

                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .1,
                        ),
                        const Text("E-mail"),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        CampoTexto(
                          hintText: "Informe seu e-mail",
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: _usuarioController.defineEmail,
                          validator: _usuarioController.emailEhValido,
                          initialValue: _usuarioController.email,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .05),
                        const Text("Senha"),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        CampoTexto(
                          hintText: "Informe sua senha",
                          prefixIcon: Icons.password_outlined,
                          obscureText: true,
                          onChanged: _usuarioController.defineSenha,
                          validator: _usuarioController.senhaEhValida,
                          initialValue: _usuarioController.senha,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        BotaoPadrao(
                          onTap: _login,
                          text: "Acessar",
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        BotaoPadrao(
                          onTap: _criarConta,
                          text: "Criar conta",
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
