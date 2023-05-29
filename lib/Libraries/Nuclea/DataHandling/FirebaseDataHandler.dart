import 'dart:convert';
import 'package:http/http.dart' as http;
import './FirebaseConstants.dart';

class FirebaseDataHandler {
  final String projectId;

  FirebaseDataHandler({this.projectId});

  Future<Map<String, dynamic>> fetch({String path}) async {
    String requestUrl =
        'https://firestore.googleapis.com/v1/projects/${this.projectId}/databases/(default)/documents/${path}';

    final response = await http.get(Uri.parse(requestUrl)).catchError((e) {
      print('Error: ${e}');
    });

    dynamic thisResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return FirebaseConstants.SuccessRequest(
        projectId: this.projectId,
        requestUrl: requestUrl,
        content: thisResponse,
      );
    } else {
      return FirebaseConstants.Error_FailedToFetch;
    }
  }

  Future<Map<String, dynamic>> post(
      {String path, Map<String, dynamic> body}) async {
    String requestUrl =
        'https://firestore.googleapis.com/v1/projects/${this.projectId}/databases/(default)/documents/${path}';

    dynamic dynamicBody =
        FirebaseConstants.formatMapForFirestore(originalMap: body);

    final response = await http.post(
      Uri.parse(requestUrl),
      body: dynamicBody,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = FirebaseConstants.SuccessRequest(
          projectId: this.projectId,
          requestUrl: requestUrl,
          content: json.decode(response.body));
      return result;
    } else {
      return FirebaseConstants.Error_FailedToFetch;
    }
  }

  Future<Map<String, dynamic>> update(
      {String path, Map<String, dynamic> body}) async {
    String requestUrl =
        'https://firestore.googleapis.com/v1/projects/${this.projectId}/databases/(default)/documents/${path}';

    dynamic dynamicBody =
        FirebaseConstants.formatMapForFirestore(originalMap: body);

    final response = await http.patch(
      Uri.parse(requestUrl),
      body: dynamicBody,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = FirebaseConstants.SuccessRequest(
          projectId: this.projectId,
          requestUrl: requestUrl,
          content: json.decode(response.body));
      return result;
    } else {
      return FirebaseConstants.Error_FailedToFetch;
    }
  }

  Future<Map<String, dynamic>> delete({String path}) async {
    String requestUrl =
        'https://firestore.googleapis.com/v1/projects/${this.projectId}/databases/(default)/documents/${path}';

    final response = await http.delete(
      Uri.parse(requestUrl),
    );
    if (response.statusCode == 200) {
      return FirebaseConstants.SuccessRequest(
          projectId: this.projectId,
          requestUrl: requestUrl,
          content: json.decode(response.body));
    } else {
      return FirebaseConstants.Error_FailedToFetch;
    }
  }
}
