import 'package:sindicatos/Model/ImageNews.dart';
import 'package:sindicatos/config.dart';

import '../Model/BenefictItem.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final config = new Config();

Future<List<BenefictItem>> fetchBeneficts() async {
  final response = await http.get(Uri.parse(
    //'https://ginevar.com/api/cgp/db/table?projectId=G7ZqMLqlr0Xt&apiKey=d3rQDCHbfoAF06wJWIx3&tableId=BjSXKJSJwaZq',
    config.url + '/items/categoriaBeneficios?sort[]=-id',
  ));

  dynamic result = json.decode(response.body);
  print(result);
  /*
    if(result['error'] != null) {
        print(result);
        List<BenefictItem> empty = [];
        return empty;
    }else{
      if(result['error'] != null) {
        return [];
      }else{
        List<dynamic> responseList = result['items'];
        
        List<BenefictItem> benefList = [];
        for(Map<String, dynamic> itemList in responseList) {
          BenefictItem benefict = await BenefictItem.fromJson(itemList);
          benefList.add(benefict);
        }

        // benefList.sort((benefB, benefA) {
        //   return benefA.date.compareTo(benefB.date);
        // });

        return benefList;
      }
    }
    */
  List<dynamic> responseList = result['data'];

  List<BenefictItem> benefList = [];
  for (Map<String, dynamic> itemList in responseList) {
    BenefictItem benefict = await BenefictItem.fromJson(itemList);
    benefList.add(benefict);
  }

  return benefList;
}

Future<List<dynamic>> fetchBenefict(String title) async {
  final response = await http.get(Uri.parse(
    // config.url + '/items/beneficios?filter={ "category": { "_eq":  "$title" }}',

    config.url +
        '/items/beneficios?filter={ "category.id": { "_eq":  "$title" }}&&fields=*.*.*&&sort[]=-id',
  ));

  Map<String, dynamic> map = json.decode(response.body);

  // print(map['data']);
  return map['data'];
}

Future<dynamic> fetchBenefictId(int id) async {
  List<ImageNews> images = [];
  final response = await http.get(Uri.parse(
    // config.url + '/items/beneficios?filter={ "category": { "_eq":  "$title" }}',

    config.url + '/items/beneficios/$id?fields=*.*.*',
  ));

  Map<String, dynamic> map = json.decode(response.body)["data"];

  for (int i = 0; i < map["imagen_multimedia"].length; i++) {
    if (map["imagen_multimedia"][i]["noticia_multimedia_id"]["url_video"] ==
        null) {
      ImageNews imageAux = ImageNews(
          image: config.url +
              "/assets/" +
              map["imagen_multimedia"][i]["noticia_multimedia_id"]["imagen"]
                  .toString(),
          video: false);
      images.add(imageAux);
    } else {
      String urlPrev;
      final startIndex = map["imagen_multimedia"][i]['noticia_multimedia_id']
                  ["url_video"]
              .toString()
              .indexOf("=") +
          1;

      urlPrev = "https://img.youtube.com/vi/" +
          map["imagen_multimedia"][i]['noticia_multimedia_id']["url_video"]
              .toString()
              .substring(
                  startIndex,
                  map["imagen_multimedia"][i]['noticia_multimedia_id']
                          ["url_video"]
                      .toString()
                      .length) +
          "/hqdefault.jpg";

      ImageNews imageAux = ImageNews(
          image: map["imagen_multimedia"][i]['noticia_multimedia_id']
                  ["url_video"]
              .toString(),
          video: true,
          prevVideo: urlPrev);
      images.add(imageAux);
    }
    // imagen.add(json["imagen_multimedia"][i]['noticia_multimedia_id']['imagen']);
  }
  // map["media"] = images;
  print(map['data']);
  return BenefictDetail(
    id: map['id'].toString(),
    title: map['titulo'],
    media: images,
    description: map['descripcion'],
    phone: map['telefono'],
    mail: map['email'],
    latitude: map['latitud'],
    longitude: map['longitud'],
    category: map['category']["nombre"],
  );
  // return map;
}

Future<BenefictCase> fetchBenefictItem({String itemId}) async {
  String urlToFetch =
      "https://ginevar.com/api/cgp/db/item?projectId=G7ZqMLqlr0Xt&apiKey=d3rQDCHbfoAF06wJWIx3&tableId=HRQ7Ub5uyl6h&itemId=" +
          itemId;

  dynamic response = await http.get(Uri.parse(urlToFetch));
  dynamic result = json.decode(response.body);

  if (result['error'] != null) {
    print(result["error"]);
    return null;
  } else {
    if (result['error'] == null) {
      return BenefictCase(
          id: result["id"],
          date: result["fecha"],
          description: result["descripcion"],
          //location: result["direccion"],
          mail: result["email"],
          media: result["imagen"],
          phone: result["telefono"],
          title: result["titulo"]);
    }
  }
}
