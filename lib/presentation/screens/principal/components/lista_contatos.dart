import 'package:contatos/models/states/sucesso_state.dart';
import 'package:contatos/presentation/components/dialogo_confirmacao.dart';
import 'package:contatos/presentation/screens/principal/components/card_contato.dart';
import 'package:flutter/material.dart';
import 'package:contatos/controllers/interface/i_principal_controller.dart';
import 'package:contatos/models/states/carregando_state.dart';
import 'package:contatos/models/states/erro_state.dart';
import 'package:contatos/models/states/inicial_state.dart';
import 'package:contatos/presentation/components/campo_texto.dart';

class ListContatos extends StatelessWidget {
  final IPrincipalController principalController;
  final ScrollController scrollController;
  final void Function(String id) editarContatoClique;
  final void Function(String id) excluirContatoClique;
  final void Function(String pesquisa) quandoPesquisar;
  final void Function(String latitude, String longitude) enderecoClique;

  const ListContatos({
    Key? key,
    required this.principalController,
    required this.scrollController,
    required this.editarContatoClique,
    required this.quandoPesquisar,
    required this.enderecoClique,
    required this.excluirContatoClique,
  }) : super(key: key);

  Future<void> _excluirClique(BuildContext context, String id) async {
    showDialog(
      context: context,
      builder: (_) => const DialogoConfirmacao(
        titulo: "Confirma exclusão do contato?",
        descricao: "Esta operação não poderá ser revertida.",
      ),
    ).then((excluir) => _executaExcluir(excluir, id));
  }

  void _executaExcluir(bool excluir, String id) {
    if (!excluir) return;

    excluirContatoClique.call(id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .4,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black54,
                  offset: Offset(1, .1),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Pesquisa"),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                CampoTexto(
                  hintText: "Pesquisar...",
                  prefixIcon: Icons.search,
                  suffixIcon: Icons.clear,
                  onChanged: quandoPesquisar,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: principalController,
                builder: (context, estado, child) {
                  if (estado is CarregandoState &&
                      principalController.contatos.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (estado is ErroState) {
                    return Container();
                  }

                  if (estado is InicialState ||
                      (estado is SucessoState && estado.valores.isEmpty)) {
                    return const Center(
                      child: Text("Nenhum resultado!"),
                    );
                  }

                  return ListView.separated(
                    controller: scrollController,
                    itemCount: principalController.contatos.length,
                    separatorBuilder: (context, indice) => const Divider(),
                    itemBuilder: (context, indice) {
                      var contato = principalController.contatos[indice];

                      return CardContato(
                        nome: contato.nome,
                        cpf: contato.cpf,
                        telefone: contato.telefone,
                        editarClique: () => editarContatoClique(contato.id),
                        excluirClique: () =>
                            _excluirClique(context, contato.id),
                        enderecoClique: () => enderecoClique(
                          contato.endereco!.latitude,
                          contato.endereco!.longitude,
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
