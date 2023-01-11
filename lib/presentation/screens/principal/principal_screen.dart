import 'dart:async';
import 'package:contatos/controllers/implementation/principal_controller.dart';
import 'package:contatos/controllers/implementation/usuario_controller.dart';
import 'package:contatos/controllers/interface/i_principal_controller.dart';
import 'package:contatos/controllers/interface/i_usuario_controller.dart';
import 'package:contatos/datasources/implementation/sqlite/contato_datasource.dart';
import 'package:contatos/datasources/implementation/sqlite/usuario_datasource.dart';
import 'package:contatos/presentation/screens/principal/components/dialogo_usuario.dart';
import 'package:contatos/presentation/screens/principal/components/lista_contatos.dart';
import 'package:contatos/repositories/implementation/contato_repository.dart';
import 'package:contatos/repositories/implementation/usuario_repository.dart';
import 'package:contatos/utils/imagem_util.dart';
import 'package:contatos/utils/routes_util.dart';
import 'package:contatos/utils/sqlite/sqlite_util.dart';
import 'package:contatos/utils/uuid_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => PrincipalScreenState();
}

class PrincipalScreenState extends State<PrincipalScreen> {
  late final IPrincipalController _principalController;
  late final IUsuarioController _usuarioController;
  late final ScrollController _scrollController;
  late final Completer<GoogleMapController> _mapaController;
  Timer? _temporizador;
  late final Set<Marker> _marcadores;

  @override
  void initState() {
    super.initState();

    _principalController = PrincipalController(
      ContatoRepository(
        ContatoDataSource(SqliteUtil.bancoDados),
      ),
    );

    Future.delayed(Duration.zero, _principalController.iniciar);

    _usuarioController = UsuarioController(
      UsuarioRepository(
        UsuarioDataSource(SqliteUtil.bancoDados),
      ),
    );

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double proximaPagina = 0.8 * _scrollController.position.maxScrollExtent;
      if (_scrollController.offset > proximaPagina) {
        _principalController.proximaPagina();
      }
    });

    _mapaController = Completer<GoogleMapController>();

    _marcadores = {};
  }

  @override
  void dispose() {
    _principalController.dispose();

    _usuarioController.dispose();

    _scrollController.dispose();

    _temporizador?.cancel();

    super.dispose();
  }

  void _opcaoConta() {
    showDialog(
      context: context,
      builder: (_) => DialogoUsuario(
        sairClique: _logOut,
        excluirContaClique: _escluirConta,
      ),
    );
  }

  Future<void> _logOut() async {
    await _usuarioController.logOut().then(
          (_) => Navigator.of(context).pushReplacementNamed(RoutesUtil.login),
        );
  }

  Future<void> _escluirConta() async {
    _usuarioController.excluirMinhaConta().then(
          (_) => Navigator.of(context).pushReplacementNamed(RoutesUtil.login),
        );
  }

  void _novoContato() {
    Navigator.of(context)
        .pushNamed(RoutesUtil.contato)
        .then((valor) => _principalController.iniciar());
  }

  void _editarContato(String idContato) {
    Navigator.of(context)
        .pushNamed(RoutesUtil.contato, arguments: idContato)
        .then((valor) => _principalController.iniciar());
  }

  void _quandoPesquisa(String pesquisa) {
    if (_temporizador?.isActive ?? false) _temporizador?.cancel();

    _temporizador = Timer(
      const Duration(milliseconds: 500),
      () {
        _principalController.definePesquisa(pesquisa);
        _principalController.pesquisar();
      },
    );
  }

  void _selecionaEndereco(String latitude, String longitude) async {
    _marcadores.clear();

    double latitudeD = double.parse(latitude);
    double longitudeD = double.parse(longitude);

    Marker marcador = Marker(
      markerId: MarkerId(UuidUtil.generate()),
      position: LatLng(latitudeD, longitudeD),
      infoWindow: const InfoWindow(
        title: "Contato",
      ),
      icon: BitmapDescriptor.fromBytes(
        await ImagemUtil.getBytesFromAsset(
            "assets/images/diversidade.png", 100),
      ),
    );

    setState(() {
      _marcadores.add(marcador);
    });

    final GoogleMapController controller = await _mapaController.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitudeD, longitudeD),
          zoom: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus contatos"),
        centerTitle: true,
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
            ListContatos(
              principalController: _principalController,
              scrollController: _scrollController,
              editarContatoClique: _editarContato,
              excluirContatoClique: _principalController.excluirContato,
              quandoPesquisar: _quandoPesquisa,
              enderecoClique: _selecionaEndereco,
            ),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-25.2548, -49.1615),
                  zoom: 10,
                ),
                markers: _marcadores,
                onMapCreated: (GoogleMapController controller) {
                  _mapaController.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: _novoContato,
          backgroundColor: Colors.blueGrey[600],
          child: const Icon(Icons.plus_one_outlined),
        ),
      ),
    );
  }
}
