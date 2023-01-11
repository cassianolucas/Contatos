import 'package:contatos/models/dto/coordenadas_dto.dart';
import 'package:geocoding/geocoding.dart';

class EnderecoUtil {
  EnderecoUtil._();

  static Future<CoordenadasDto> buscarCoordenadasPorEndereco(
      String endereco) async {
    var locations = await locationFromAddress(endereco.toString());

    return CoordenadasDto(
      latitude: locations.first.latitude.toString(),
      longitude: locations.first.longitude.toString(),
    );
  }
}
