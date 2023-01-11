import 'package:contatos/presentation/components/botao_padrao.dart';
import 'package:contatos/presentation/components/dialogo_padrao.dart';
import 'package:flutter/material.dart';

class DialogoUsuario extends StatelessWidget {
  final VoidCallback sairClique;
  final VoidCallback excluirContaClique;

  const DialogoUsuario({
    super.key,
    required this.sairClique,
    required this.excluirContaClique,
  });

  @override
  Widget build(BuildContext context) {
    return DialogoPadrao(
      children: [
        BotaoPadrao(
          onTap: () {
            Navigator.of(context).pop();
            sairClique.call();
          },
          text: "Sair",
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        BotaoPadrao(
          onTap: () {
            Navigator.of(context).pop();
            excluirContaClique.call();
          },
          text: "Excluir conta",
        ),
      ],
    );
  }
}
