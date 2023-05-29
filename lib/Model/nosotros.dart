import 'package:sindicatos/config.dart';

class Nosotros {
  final String id;
  final String name;
  final String preview;
  final String description;
  final String cargo;

  Nosotros({this.id, this.name, this.preview, this.description, this.cargo});

  factory Nosotros.fromJson(Map<String, dynamic> json) {
    Config config = new Config();

    Map<String, dynamic> fields = json;

    Nosotros nosotros = Nosotros(
        id: fields['id'].toString(),
        name: fields['nombre'].toString(),
        preview: config.url + "/assets/" + fields["imagen"],
        description: fields['descripcion'].toString(),
        cargo: fields["cargo"].toString());

    return nosotros;
  }
}
