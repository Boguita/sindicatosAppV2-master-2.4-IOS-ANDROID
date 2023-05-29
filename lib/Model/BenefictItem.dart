import 'package:sindicatos/Model/ImageNews.dart';
import 'package:sindicatos/Network/BenefictCalls.dart';
import 'package:sindicatos/config.dart';

class BenefictItem {
  final String id;
  final String title;
  final List<String> icon;

  BenefictItem({
    this.id,
    this.title,
    this.icon,

  });

  static Future<BenefictItem> fromJson(Map<String, dynamic> jsonItem) async {
    Config config = new Config();

    Map<String, dynamic> fields = jsonItem;
    List<String> images = [];

    for (int i = 0; i < fields["imagen"].length; i++) {
      images.add(config.url + "/assets/" + fields["imagen"]);
    }

    BenefictItem benefict = BenefictItem(
      id: fields['id'].toString(),
      title: fields['nombre'],
      icon: images,
    );

    return benefict;
  }
}

class BenefictCase {
  final String id;
  final String title;
  final String media;
  final String description;
  final String phone;
  final String mail;
  final String date;

  BenefictCase(
      {this.id,
      this.title,
      this.media,
      this.description,
      this.phone,
      this.mail,
      this.date});

  factory BenefictCase.fromJson(Map<String, dynamic> json) {
    return BenefictCase(
        id: json['id'],
        title: Uri.decodeComponent(json['titulo']),
        media: json['media'],
        description: Uri.decodeComponent(json['description']),
        phone: json['phone'],
        mail: json['email'],
        date: json['date']);
  }
}

class BenefictDetail {
  final String id;
  final String title;
  final List<ImageNews> media;
  final String description;
  final String phone;
  final String mail;
  final double latitude;
  final double longitude;
  final String category;

  BenefictDetail({
    this.id,
    this.title,
    this.media,
    this.description,
    this.phone,
    this.mail,
    this.longitude,
    this.latitude,
    this.category,
  });

  factory BenefictDetail.fromJson(Map<String, dynamic> json) {
    List<ImageNews> images = [];

    for (int i = 0; i < json["imagen_multimedia"].length; i++) {
      if (json["imagen_multimedia"][i]["noticia_multimedia_id"]["url_video"] ==
          null) {
        ImageNews imageAux = ImageNews(
            image: config.url +
                "/assets/" +
                json["imagen_multimedia"][i]["noticia_multimedia_id"]["imagen"]
                    .toString(),
            video: false);
        images.add(imageAux);
      } else {
        String urlPrev;
        final startIndex = json["imagen_multimedia"][i]['noticia_multimedia_id']
                    ["url_video"]
                .toString()
                .indexOf("=") +
            1;

        urlPrev = "https://img.youtube.com/vi/" +
            json["imagen_multimedia"][i]['noticia_multimedia_id']["url_video"]
                .toString()
                .substring(
                    startIndex,
                    json["imagen_multimedia"][i]['noticia_multimedia_id']
                            ["url_video"]
                        .toString()
                        .length) +
            "/hqdefault.jpg";

        ImageNews imageAux = ImageNews(
            image: json["imagen_multimedia"][i]['noticia_multimedia_id']
                    ["url_video"]
                .toString(),
            video: true,
            prevVideo: urlPrev);
        images.add(imageAux);
      }
    }

    return BenefictDetail(
      id: json['id'].toString(),
      title: json['titulo'],
      media: images,
      description: json['descripcion'],
      phone: json['telefono'],
      mail: json['email'],
      latitude: json['latitud'],
      longitude: json['longitud'],
    );
  }
}
