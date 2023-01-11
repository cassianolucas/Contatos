import 'package:contatos/presentation/components/botao_padrao.dart';
import 'package:contatos/presentation/components/dialogo_padrao.dart';
import 'package:flutter/material.dart';

class DialogoConfirmacao extends StatelessWidget {
  final String titulo;
  final String? descricao;

  const DialogoConfirmacao({
    super.key,
    required this.titulo,
    this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return DialogoPadrao(
      children: [
        Center(
          child: Text(
            titulo,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        if (descricao != null) Center(child: Text(descricao!)),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        BotaoPadrao(
          onTap: () => Navigator.of(context).pop(true),
          text: "Sim",
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        BotaoPadrao(
          onTap: () => Navigator.of(context).pop(false),
          text: "Não",
        ),
      ],
    );
  }
}
