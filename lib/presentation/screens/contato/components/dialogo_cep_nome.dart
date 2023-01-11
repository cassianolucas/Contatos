import 'package:contatos/presentation/components/botao_padrao.dart';
import 'package:contatos/presentation/components/dialogo_padrao.dart';
import 'package:flutter/material.dart';

class DialogoCepNome extends StatelessWidget {
  final VoidCallback cliqueCep;
  final VoidCallback cliqueNome;

  const DialogoCepNome({
    super.key,
    required this.cliqueCep,
    required this.cliqueNome,
  });

  void _fechar(BuildContext context, VoidCallback evento) {
    Navigator.of(context).pop();

    evento.call();
  }

  @override
  Widget build(BuildContext context) {
    return DialogoPadrao(
      children: [
        const Center(
          child: Text(
            "Buscar endereço",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        BotaoPadrao(
          onTap: () => _fechar(context, cliqueCep),
          text: "Cep",
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        BotaoPadrao(
          onTap: () => _fechar(context, cliqueNome),
          text: "Nome",
        ),
      ],
    );
  }
}
