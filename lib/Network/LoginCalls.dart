import 'package:sindicatos/config.dart';

import '../Model/History.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final config = new Config();

Future<History> fetchHistory() async {
  String url =
      '/items/Historia_files?fields[]=id&fields[]=directus_files_id&filter[id][_in]=';
  final response =
      await http.get(Uri.parse(config.url + '/items/Historia?fields=*.*.*'));
  // print(response.body);
  dynamic result = json.decode(response.body);
  print(result["data"]);

  // if (result["data"][0]['imagenes'].length > 0) {
  // for (var i = 0; i < result["data"][0]['imagenes'].length; i++) {
  //   if (i == 0) {
  //     url = url + result["data"][0]['imagenes'][i].toString();
  //   } else {
  //     url = url + ',' + result["data"][0]['imagenes'][i].toString();
  //   }
  // }
  // final responseFile = await http.get(Uri.parse(config.url + url));
  // dynamic resultFile = json.decode(responseFile.body);
  // print(resultFile["data"]);
  // for (var i = 0; i < result["data"][0]['imagenes'].length; i++) {
  //   result["data"][0]['imagenes'][i] =
  //       resultFile["data"][i]['directus_files_id'];
  // }
  // }
  History history = History.fromJson(result["data"][0]);
  // /items/Historia_files?fields[]=id&fields[]=directus_files_id&filter[id][_in]=1,2

  return history;
  //dynamic responseList = result;

  /*List<History> historyList = [];
      for(Map<String, dynamic> itemList in responseList) {
        History history = History.fromJson(itemList);
        historyList.add(history);
      }
      */
}
