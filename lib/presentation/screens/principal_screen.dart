import 'package:contatos/presentation/components/botao_padrao.dart';
import 'package:contatos/presentation/components/campo_texto.dart';
import 'package:flutter/material.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => PprincipalScreenState();
}

class PprincipalScreenState extends State<PrincipalScreen> {
  void _opcaoConta() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BotaoPadrao(
                onTap: () {
                  Navigator.of(context).pop();
                },
                text: "Sair",
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              BotaoPadrao(
                onTap: () {
                  Navigator.of(context).pop();
                },
                text: "Excluir conta",
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _opcaoConta,
            icon: const Icon(Icons.account_circle_rounded),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .4,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Meus contatos",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
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
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 50,
                      separatorBuilder: (context, indice) => const Divider(),
                      itemBuilder: (context, indice) {
                        return ListTile(
                          title: Text("titulo"),
                          subtitle: Text("data"),
                          leading: Icon(Icons.person),
                          trailing: Icon(Icons.edit),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.plus_one_outlined),
        ),
      ),
    );
  }
}
