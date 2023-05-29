import 'package:sindicatos/Model/Contact.dart';
import 'package:sindicatos/Model/Province.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sindicatos/config.dart';

Config config = new Config();

Future<List<Contact>> fetchContact() async {
  final response = await http.get(Uri.parse(config.url + '/items/sedes'));

  dynamic result = json.decode(response.body);
  print(result);
  /*
    if(result['error'] != null) {
        print(result);
    }else{
      List<dynamic> responseList = result;
      
      List<Contact> contactList = [];
        for(Map<String, dynamic> itemList in responseList) {
          Contact contact = await Contact.fromJson(itemList);
          contactList.add(contact);
        }

        return contactList.first;
    }
    */

  List<dynamic> responseList = result['data'];

  List<Contact> contactList = [];
  for (Map<String, dynamic> itemList in responseList) {
    Contact contact = await Contact.fromJson(itemList);
    contactList.add(contact);
  }

  return contactList;
}

Future<Province> fetchProvince({String itemId}) async {
  final response = await http.get(Uri.parse(
    'https://ginevar.com/api/cgp/db/item?projectId=G7ZqMLqlr0Xt&apiKey=d3rQDCHbfoAF06wJWIx3&tableId=YCB4r1AxvCij&itemId=' +
        itemId,
  ));

  dynamic result = json.decode(response.body);

  if (result['error'] != null) {
    print(result);
  } else {
    Map<String, dynamic> responseMap = result;

    List<Delegation> delegationsArray = [];
    String delegationsStr =
        responseMap["delegaciones"].toString().split(", ").join(",");
    List<String> delegationsToFetch = [];

    if (delegationsStr.contains(",")) {
      List<String> values = delegationsStr.split(",");
      delegationsToFetch.addAll(values);
    } else {
      delegationsToFetch.add(delegationsStr);
    }

    return Future.wait(delegationsToFetch
            .map((delItem) => fetchDelegation(itemId: delItem)))
        .then((List<Delegation> response) {
      delegationsArray.addAll(response);

      delegationsArray.sort((provA, provB) {
        return provA.title.compareTo(provB.title);
      });

      Province province = Province(
          id: responseMap["id"],
          title: responseMap["titulo"],
          delegations: delegationsArray);

      return province;
    });
  }
}

Future<Delegation> fetchDelegation({String itemId}) async {
  final response = await http.get(Uri.parse(
    'https://ginevar.com/api/cgp/db/item?projectId=G7ZqMLqlr0Xt&apiKey=d3rQDCHbfoAF06wJWIx3&tableId=TX40vlsUwyme&itemId=' +
        itemId,
  ));

  dynamic result = json.decode(response.body);

  if (result['error'] != null) {
    print(result);
  } else {
    Map<String, dynamic> responseMap = result;

    return Delegation(
        id: responseMap["id"],
        address: responseMap["direccion"],
        phone: responseMap["telefono"],
        title: responseMap["titulo"]);
  }
}
