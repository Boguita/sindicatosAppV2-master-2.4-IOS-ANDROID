import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleLocationHelper {
  final LatLng coordinates;

  GoogleLocationHelper({this.coordinates});

  factory GoogleLocationHelper.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonResults = json['features'];

    if (jsonResults.length == 0) {
      return GoogleLocationHelper(
        coordinates: LatLng(0, 0),
      );
    }

    dynamic firstResult = jsonResults.first;
    dynamic geometryResult = firstResult['geometry'];

    dynamic mercatorResults = geometryResult['coordinates'];

    GoogleLocationHelper helper = GoogleLocationHelper(
        coordinates: LatLng(
      double.parse(mercatorResults.last.toString()),
      double.parse(mercatorResults.first.toString()),
    ));

    return helper;
  }
}
