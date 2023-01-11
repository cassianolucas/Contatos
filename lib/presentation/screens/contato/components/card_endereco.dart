import 'package:flutter/material.dart';

class CardEndereco extends StatelessWidget {
  final String cep;
  final String uf;
  final String localidade;
  final String logradouro;
  final String bairro;
  final String? complemento;
  final VoidCallback cliqueEndereco;
  final bool mostraRemover;

  const CardEndereco({
    super.key,
    required this.cep,
    required this.uf,
    required this.localidade,
    required this.logradouro,
    required this.bairro,
    this.complemento,
    required this.cliqueEndereco,
    this.mostraRemover = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue[100],
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: cliqueEndereco,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Cep: $cep"),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .01),
                        Text("Uf: $uf"),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .01),
                        Text("Cidade: $localidade"),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * .01),
                    Text("Logradouro: $logradouro"),
                    SizedBox(height: MediaQuery.of(context).size.width * .01),
                    Text("Bairro: $bairro"),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * .01,
                    ),
                    Row(
                      children: [
                        if (complemento != null && complemento!.isNotEmpty)
                          Text("Complemento: $complemento"),
                      ],
                    ),
                  ],
                ),
              ),
              if (mostraRemover)
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
