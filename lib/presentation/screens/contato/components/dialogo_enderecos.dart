import 'package:contatos/models/dto/endereco_dto.dart';
import 'package:contatos/presentation/components/dialogo_padrao.dart';
import 'package:contatos/presentation/screens/contato/components/card_endereco.dart';
import 'package:flutter/material.dart';

class DialogoEnderecos extends StatelessWidget {
  final List<EnderecoDto> enderecos;
  final void Function(EnderecoDto endereco) enderecoClique;

  const DialogoEnderecos({
    super.key,
    required this.enderecos,
    required this.enderecoClique,
  });

  @override
  Widget build(BuildContext context) {
    return DialogoPadrao(
      children: [
        const Center(
          child: Text(
            "Selecione seu endereço",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
        ),
        Column(
          children: List.generate(
            enderecos.length,
            (indice) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: CardEndereco(
                cep: enderecos[indice].cep,
                uf: enderecos[indice].uf,
                localidade: enderecos[indice].localidade,
                logradouro: enderecos[indice].logradouro,
                bairro: enderecos[indice].bairro,
                mostraRemover: false,
                cliqueEndereco: () {
                  Navigator.of(context).pop();

                  enderecoClique.call(enderecos[indice]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
