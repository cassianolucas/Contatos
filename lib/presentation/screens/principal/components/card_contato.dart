import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class CardContato extends StatelessWidget {
  final String nome;
  final String cpf;
  final String telefone;
  final VoidCallback editarClique;
  final VoidCallback excluirClique;
  final VoidCallback enderecoClique;

  const CardContato({
    super.key,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.editarClique,
    required this.excluirClique,
    required this.enderecoClique,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(nome),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          Text("Cpf: ${UtilBrasilFields.obterCpf(cpf)}"),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Text("Telefone: ${UtilBrasilFields.obterTelefone(telefone)}"),
        ],
      ),
      leading: const Icon(Icons.person),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: editarClique,
            child: const Icon(Icons.edit),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .01,
          ),
          GestureDetector(
            onTap: excluirClique,
            child: const Icon(Icons.clear),
          ),
        ],
      ),
      onTap: enderecoClique,
    );
  }
}
