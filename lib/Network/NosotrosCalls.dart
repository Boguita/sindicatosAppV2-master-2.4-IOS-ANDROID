import 'package:sindicatos/Model/nosotros.dart';
import 'package:sindicatos/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final config = new Config();

Future<List<Nosotros>> fetchNosotros() async {
  final response = await http.get(Uri.parse(
    //'https://ginevar.com/api/cgp/db/table?projectId=G7ZqMLqlr0Xt&apiKey=d3rQDCHbfoAF06wJWIx3&tableId=36adMp3N8OML',
    config.url + '/items/nosotros?sort[]=-id',
  ));
  dynamic result = json.decode(response.body);
  print(result);

  List<dynamic> responseList = result["data"];

  List<Nosotros> nosotrosList = [];
  for (Map<String, dynamic> itemList in responseList) {
    Nosotros nosotros = Nosotros.fromJson(itemList);
    nosotrosList.add(nosotros);
  }

  return nosotrosList;
}
