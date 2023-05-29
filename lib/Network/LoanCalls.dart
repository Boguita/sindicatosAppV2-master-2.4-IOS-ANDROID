import 'package:sindicatos/Model/Loan.dart';
import 'package:sindicatos/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final config = new Config();

Future<List<Loan>> getPrestamos() async {
  final response = await http.get(Uri.parse(
    config.url + '/items/Escalas_Salariales?limit=-1',
  ));
  print(response.body);
  dynamic result = json.decode(response.body);

  List<dynamic> responseList = result["data"];

  List<Loan> loanList = [];
  for (Map<String, dynamic> itemList in responseList) {
    Loan loan = Loan.fromJson(itemList);
    loanList.add(loan);
  }

  return loanList;
}

Future<List<String>> getAnos() async {
  final response = await http.get(Uri.parse(
    config.url + '/items/Escalas_Salariales?fields=ano',
  ));
  print(response.body);
  dynamic result = json.decode(response.body);

  List<dynamic> responseList = result["data"];

  List<String> loanList = [];
  for (Map<dynamic, dynamic> itemList in responseList) {
    String loan = itemList["ano"].toString();
    loanList.add(loan);
  }

  return loanList.toSet().toList();
}

Future<List<Loan>> getResoluciones(ano, search) async {
  String url;
  if (ano == "Todos los Años") {
    url = config.url + '/items/Escalas_Salariales?search=${search}';
  } else {
    url = config.url +
        '/items/Escalas_Salariales?filter={"ano":{"_eq":${ano}}}&search=${search}';
  }
  final response = await http.get(Uri.parse(url));
  print(response.body);
  dynamic result = json.decode(response.body);

  List<dynamic> responseList = result["data"];

  List<Loan> loanList = [];
  for (Map<String, dynamic> itemList in responseList) {
    Loan loan = Loan.fromJson(itemList);
    loanList.add(loan);
  }

  return loanList;
}
