import 'package:contatos/presentation/components/botao_padrao.dart';
import 'package:contatos/presentation/components/campo_texto.dart';
import 'package:contatos/presentation/components/dialogo_padrao.dart';
import 'package:flutter/material.dart';

class DialogoBuscarPorNome extends StatefulWidget {
  final void Function(String uf, String cidade, String logradouro) buscarClique;

  const DialogoBuscarPorNome({
    super.key,
    required this.buscarClique,
  });

  @override
  State<DialogoBuscarPorNome> createState() => _DialogoBuscarPorNomeState();
}

class _DialogoBuscarPorNomeState extends State<DialogoBuscarPorNome> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _ufController;
  late final TextEditingController _cidadeController;
  late final TextEditingController _logradouroController;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();

    _ufController = TextEditingController();
    _cidadeController = TextEditingController();
    _logradouroController = TextEditingController();
  }

  @override
  void dispose() {
    _ufController.dispose();
    _cidadeController.dispose();
    _logradouroController.dispose();

    super.dispose();
  }

  String? validaSigla(String? sigla) {
    if (sigla == null || sigla.isEmpty || sigla.length < 2) {
      return "Sigla não válida";
    }

    return null;
  }

  String? validaCidade(String? cidade) {
    if (cidade == null || cidade.isEmpty) {
      return "Necessário informar uma cidade";
    }

    return null;
  }

  String? _validaLogradouro(String? logradouro) {
    if (logradouro == null || logradouro.isEmpty || logradouro.length < 3) {
      return "Necessário informar logradouro (mínimo 3 caracteres)";
    }

    return null;
  }

  void _buscar() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();

      widget.buscarClique.call(
        _ufController.text,
        _cidadeController.text,
        _logradouroController.text,
      );
    }
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
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Uf"),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              CampoTexto(
                hintText: "Informe a uf (sigla)",
                controller: _ufController,
                maxLength: 2,
                onChanged: (valor) {
                  _formKey.currentState!.validate();
                },
                validator: validaSigla,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              const Text("Cidade"),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              CampoTexto(
                hintText: "Informe a cidade",
                controller: _cidadeController,
                onChanged: (valor) {
                  _formKey.currentState!.validate();
                },
                validator: validaCidade,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              const Text("Logradouro"),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              CampoTexto(
                hintText: "Informe o logradouro (minimo 3 caracteres)",
                controller: _logradouroController,
                onChanged: (valor) {
                  _formKey.currentState!.validate();
                },
                validator: _validaLogradouro,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              BotaoPadrao(
                onTap: _buscar,
                text: "Buscar",
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
      ],
    );
  }
}
