import 'dart:convert';
import '../Model/News.dart';
import 'package:sindicatos/config.dart';
import 'package:http/http.dart' as http;

final config = new Config();

Future<List<News>> get fetchNews async {
  final response = await http.get(Uri.parse(config.url + '/items/Noticia?fields=*.*.*&sort[]=-id'));
  // final response = await http.get(Uri.parse(config.url + '/items/noticia?fields=*,imagenes.directus_files_id'));

  dynamic result = json.decode(response.body);

  print(result);
  List<dynamic> responseList = result["data"];

  List<News> newsList = [];
  for (Map<String, dynamic> itemList in responseList) {
    News news = News.fromJson(itemList);
    newsList.add(news);
  }

  return newsList;
}
