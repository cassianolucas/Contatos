import 'package:brasil_fields/brasil_fields.dart';
import 'package:contatos/controllers/implementation/contato_controller.dart';
import 'package:contatos/controllers/interface/i_contato_controller.dart';
import 'package:contatos/datasources/implementation/sqlite/contato_datasource.dart';
import 'package:contatos/models/entities/contato_entity.dart';
import 'package:contatos/models/states/carregando_state.dart';
import 'package:contatos/models/states/erro_state.dart';
import 'package:contatos/models/states/sucesso_state.dart';
import 'package:contatos/presentation/components/botao_padrao.dart';
import 'package:contatos/presentation/components/campo_texto.dart';
import 'package:contatos/presentation/components/dialogo_confirmacao.dart';
import 'package:contatos/presentation/screens/contato/components/card_endereco.dart';
import 'package:contatos/presentation/screens/contato/components/dialogo_buscar_por_cep.dart';
import 'package:contatos/presentation/screens/contato/components/dialogo_buscar_por_nome.dart';
import 'package:contatos/presentation/screens/contato/components/dialogo_cep_nome.dart';
import 'package:contatos/presentation/screens/contato/components/dialogo_enderecos.dart';
import 'package:contatos/repositories/implementation/contato_repository.dart';
import 'package:contatos/services/implementation/viacep_service.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContatoScreen extends StatefulWidget {
  const ContatoScreen({super.key});

  @override
  State<ContatoScreen> createState() => _NovoContatoScreenState();
}

class _NovoContatoScreenState extends State<ContatoScreen> {
  late final IContatoController _contatoController;
  late final GlobalKey<FormState> _formKey;
  String? idContato;

  @override
  void initState() {
    super.initState();

    _contatoController = ContatoController(
      ContatoRepository(
        ContatoDataSource(SqliteUtil.bancoDados),
      ),
      ViaCepService(Dio()),
    );

    _contatoController.addListener(_monitoraStatus);

    _formKey = GlobalKey<FormState>();

    Future.delayed(Duration.zero, () {
      idContato = ModalRoute.of(context)?.settings.arguments as String?;

      if (idContato != null) {
        _contatoController.buscarPorId(idContato!);
      }
    });
  }

  @override
  void dispose() {
    _contatoController.removeListener(_monitoraStatus);

    _contatoController.dispose();

    super.dispose();
  }

  void _monitoraStatus() {
    if (_contatoController.value is SucessoState) {
      if ((_contatoController.value as SucessoState).valores is ContatoEntity) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cadastro realizado com sucesso!"),
            backgroundColor: Colors.greenAccent,
          ),
        );
      }
    } else if (_contatoController.value is ErroState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((_contatoController.value as ErroState).mensagem),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<bool> _fechar() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const DialogoConfirmacao(
        titulo: "Confirma cancelamento?",
        descricao: "Todo processo será perdido!",
      ),
    );
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      await _contatoController.salvar();
    }
  }

  void _buscarEndereco() {
    showDialog(
      context: context,
      builder: (_) => DialogoCepNome(
        cliqueCep: _buscarEnderecoPorCep,
        cliqueNome: _buscarEnderecoPorNome,
      ),
    );
  }

  void _buscarEnderecoPorCep() {
    showDialog(
      context: context,
      builder: (_) => DialogoBuscarPorCep(
        buscarClique: _contatoController.buscarPorCep,
      ),
    );
  }

  void _buscarEnderecoPorNome() {
    showDialog(
      context: context,
      builder: (_) => DialogoBuscarPorNome(
        buscarClique: (uf, cidade, logradouro) async {
          var enderecos = await _contatoController.buscarPorPesquisa(
            uf,
            cidade,
            logradouro,
          );

          showDialog(
            context: context,
            builder: (_) => DialogoEnderecos(
              enderecos: enderecos,
              enderecoClique: _contatoController.selecionaEndereco,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _fechar,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Novo contato"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .3,
            ),
            child: ValueListenableBuilder(
              valueListenable: _contatoController,
              builder: (context, estado, child) {
                if (estado is CarregandoState) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        const Text("Nome completo"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        CampoTexto(
                          hintText: "Informe o nome completo",
                          prefixIcon: Icons.email_outlined,
                          onChanged: _contatoController.defineNome,
                          validator: _contatoController.nomeEhValido,
                          initialValue: _contatoController.nome,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        const Text("Cpf"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        CampoTexto(
                          hintText: "Informe o cpf",
                          prefixIcon: Icons.person,
                          keyboardType: TextInputType.number,
                          onChanged: _contatoController.defineCpf,
                          validator: _contatoController.cpfEhValido,
                          initialValue: _contatoController.cpf,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CpfInputFormatter(),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        const Text("Telefone"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        CampoTexto(
                          hintText: "Informe o telefone",
                          prefixIcon: Icons.phone_android,
                          keyboardType: TextInputType.number,
                          onChanged: _contatoController.defineTelefone,
                          validator: _contatoController.telefoneEhValido,
                          initialValue: _contatoController.telefone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        const Text("Endereço"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        if (_contatoController.endereco == null)
                          InkWell(
                            onTap: _buscarEndereco,
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                "Toque para buscar um endereço",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        if (_contatoController.endereco != null)
                          CardEndereco(
                            cep: _contatoController.endereco!.cep,
                            uf: _contatoController.endereco!.uf,
                            localidade: _contatoController.endereco!.localidade,
                            logradouro: _contatoController.endereco!.logradouro,
                            bairro: _contatoController.endereco!.bairro,
                            complemento:
                                _contatoController.endereco!.complemento,
                            cliqueEndereco: () =>
                                _contatoController.defineEndereco(null),
                          ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        BotaoPadrao(
                          onTap: _salvar,
                          text: "Salvar",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
