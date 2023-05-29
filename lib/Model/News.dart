import 'package:sindicatos/Model/ImageNews.dart';
import 'package:sindicatos/config.dart';

class News {
  final String id;
  final String title;
  final List<ImageNews> imageUrl;
  final String shortDescription;
  final String content;
  final String date;

  News(
      {this.id,
      this.title,
      this.imageUrl,
      this.shortDescription,
      this.content,
      this.date});

  factory News.fromJson(Map<String, dynamic> json) {
    Config config = new Config();
    Map<String, dynamic> fields = json;
    List<ImageNews> images = [];

    for (int i = 0; i < fields["imagen_multimedia"].length; i++) {
      if (fields["imagen_multimedia"][i]["noticia_multimedia_id"]
              ["url_video"] ==
          null) {
        ImageNews imageAux = ImageNews(
            image: config.url +
                "/assets/" +
                fields["imagen_multimedia"][i]["noticia_multimedia_id"]
                        ["imagen"]
                    .toString(),
            video: false);
        images.add(imageAux);
      } else {
        String urlPrev;
        final startIndex = fields["imagen_multimedia"][i]
                    ['noticia_multimedia_id']["url_video"]
                .toString()
                .indexOf("=") +
            1;

        urlPrev = "https://img.youtube.com/vi/" +
            fields["imagen_multimedia"][i]['noticia_multimedia_id']["url_video"]
                .toString()
                .substring(
                    startIndex,
                    fields["imagen_multimedia"][i]['noticia_multimedia_id']
                            ["url_video"]
                        .toString()
                        .length) +
            "/hqdefault.jpg";

        ImageNews imageAux = ImageNews(
            image: fields["imagen_multimedia"][i]['noticia_multimedia_id']
                    ["url_video"]
                .toString(),
            video: true,
            prevVideo: urlPrev);
        images.add(imageAux);
      }
    }

    News news = News(
        id: fields['id'].toString(),
        title: fields['titulo'].toString(),
        imageUrl: images,
        shortDescription: fields['contenido'].toString(),
        content: fields['contenido'].toString(),
        date: fields['Fecha'].toString());

    return news;
  }
}
