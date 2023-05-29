import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/Helper/DataSaver.dart';

Future<String> fetchTelemedicine(UserSaved userSaved) async {
  String providerUrl = "https://api.llamandoaldoctor.com/patient/token";

  final map = {
    'email': userSaved.email,
    'name': '${userSaved.name} ${userSaved.lastName}',
    'documentNumber': userSaved.dni,
    'phone': userSaved.phone,
    'birthDate': userSaved.birthdate
  };

  map['provider'] = "5d0a50a08ba7ae008406e0be";

  final response = await http.post(Uri.parse(providerUrl), body: map);

  print(response);

  if (response.statusCode == 201) {
    String token = json.decode(response.body)['token'].toString();
    String url = 'https://app.llamandoaldoctor.com/?token=${token}';
    return url;
  } else {
    throw Exception('Failed to load telemedicine');
  }
}
