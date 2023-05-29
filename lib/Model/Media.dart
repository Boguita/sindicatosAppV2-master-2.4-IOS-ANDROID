import 'package:sindicatos/config.dart';

class Media {
  final String id;
  final String title;
  final List<String> preview;
  final String link;
  final String content;
  final String date;

  Media(
      {this.id, this.title, this.preview, this.link, this.content, this.date});

  factory Media.fromJson(Map<String, dynamic> json) {
    Config config = new Config();

    Map<String, dynamic> fields = json;
    List<String> images = [];

    for (int i = 0; i < fields["multimedia"].length; i++) {
      images.add(config.url + "/assets/" + fields["multimedia"]);
    }

    Media media = Media(
        id: fields['id'].toString(),
        title: fields['titulo'].toString(),
        preview: images,
        link: fields['url'].toString(),
        content: fields['descripcion'].toString(),
        date: fields['fecha'].toString());

    return media;
  }
}
