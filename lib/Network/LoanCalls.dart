import 'package:sindicatos/Model/Loan.dart';
import 'package:sindicatos/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final config = new Config();

Future<List<Loan>> getPrestamos() async {
  final response = await http.get(Uri.parse(
    config.url + '/items/Escalas_Salariales?limit=-1',
  ));

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
    config.url + '/items/Escalas_Salariales?limit=-1',
  ));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final dataList = jsonData['data'] as List<dynamic>;
    final anosSet = <String>{};
    dataList.forEach((item) {
      final ano = item['ano'].toString();
      anosSet.add(ano);
    });
    final anosList = anosSet.toList();
    anosList.sort((a, b) => b.compareTo(a)); // Ordenar de forma descendente
    return anosList;
  } else {
    throw Exception('Failed to fetch anos');
  }
}


Future<List<Loan>> getResoluciones(ano, search) async {
  String url;
  if (ano == "Todos los Años") {
    url = config.url + '/items/Escalas_Salariales?search=${search}&limit=-1';
  } else {
    if (search == "") {
      url = config.url +
          '/items/Escalas_Salariales?filter={"ano":{"_eq":${ano}}}&limit=-1';
    } else {
      url = config.url +
          '/items/Escalas_Salariales?filter={"ano":{"_eq":${ano}}}&search=${search}&limit=-1';
    }
  }

  final response = await http.get(Uri.parse(url));
  dynamic result = json.decode(response.body);
  print(response.body);
  List<dynamic> responseList = result["data"];

  List<Loan> loanList = [];
  for (Map<String, dynamic> itemList in responseList) {
    Loan loan = Loan.fromJson(itemList);
    loanList.add(loan);
  }

  // Ordenar la lista de préstamos
  loanList.sort((loan1, loan2) {
    // Ordenar por año en forma descendente
    int yearComparison = loan2.ano.compareTo(loan1.ano);
    if (yearComparison != 0) {
      return yearComparison;
    }
    // Ordenar por número de resolución en forma descendente
    return loan2.numero.compareTo(loan1.numero);
  });

  print(loanList);
  return loanList;
}
