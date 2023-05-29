import 'package:sindicatos/config.dart';
import '../Model/Media.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final config = new Config();

Future<List<Media>> fetchMedia() async {
  final response = await http.get(Uri.parse(
    //'https://ginevar.com/api/cgp/db/table?projectId=G7ZqMLqlr0Xt&apiKey=d3rQDCHbfoAF06wJWIx3&tableId=36adMp3N8OML',
    config.url + '/items/Multimedias?sort[]=-Sort',
  ));
  dynamic result = json.decode(response.body);
  print(result);

  /*
    if(result['error'] != null) {
        print(result);
        List<Media> empty = [];
        return empty;
    }else{
      if(result['error'] != null) {
        return [];
      }else{
        List<dynamic> responseList = result['items'];
        
        List<Media> mediaList = [];
        for(Map<String, dynamic> itemList in responseList) {
          Media media = Media.fromJson(itemList);
          mediaList.add(media);
        }
        mediaList.sort((mediaB, mediaA) {
          return mediaB.date.compareTo(mediaA.date);
        });
        return mediaList;
      }
    }
    */
  List<dynamic> responseList = result["data"];

  List<Media> mediaList = [];
  for (Map<String, dynamic> itemList in responseList) {
    Media media = Media.fromJson(itemList);
    mediaList.add(media);
  }

  return mediaList;
}
