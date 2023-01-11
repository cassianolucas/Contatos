import 'package:brasil_fields/brasil_fields.dart';
import 'package:contatos/helpers/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:contatos/presentation/components/botao_padrao.dart';
import 'package:contatos/presentation/components/campo_texto.dart';
import 'package:contatos/presentation/components/dialogo_padrao.dart';

class DialogoBuscarPorCep extends StatefulWidget {
  final void Function(String cep) buscarClique;

  const DialogoBuscarPorCep({
    Key? key,
    required this.buscarClique,
  }) : super(key: key);

  @override
  State<DialogoBuscarPorCep> createState() => _DialogoBuscarPorCepState();
}

class _DialogoBuscarPorCepState extends State<DialogoBuscarPorCep> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
  }

  String? _validaCep(String? cep) {
    if (cep == null) return null;

    if (cep.somenteNumero().length != 8) return "Cep deve conter 8 digitos!";

    return null;
  }

  void _buscar(String cep) {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();

      widget.buscarClique.call(cep.somenteNumero());
    }
  }

  @override
  Widget build(BuildContext context) {
    String cep = "";

    return DialogoPadrao(
      children: [
        const Center(
          child: Text(
            "Informe o cep",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        const Text("Cep"),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        Form(
          key: _formKey,
          child: CampoTexto(
            hintText: "Informe um cep",
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            prefixIcon: Icons.search,
            onChanged: (valor) => cep = valor,
            validator: _validaCep,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        BotaoPadrao(
          onTap: () => _buscar(cep),
          text: "Buscar",
        ),
      ],
    );
  }
}
