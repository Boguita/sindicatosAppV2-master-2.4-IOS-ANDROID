import 'Province.dart';

class Contact {
  final String name;
  final String id;
  final String address;
  final String phone;
  final String email;
  final double latitude;
  final double longitude;

  final List<Province> provinces;

  Contact({
    this.name,
    this.address,
    this.id,
    this.phone,
    this.email,
    this.provinces,
    this.latitude,
    this.longitude,
  });

  static Future<Contact> fromJson(Map<String, dynamic> jsonItem) async {
    Map<String, dynamic> fields = jsonItem;

    List<Province> provincesArray = [];
    String provinciasStr =
        fields["provincias"].toString().split(", ").join(",");
    List<String> provincesToFetch = [];

    if (provinciasStr.contains(",")) {
      List<String> values = provinciasStr.split(",");
      provincesToFetch.addAll(values);
    } else {
      provincesToFetch.add(provinciasStr);
    }

    Contact contact = Contact(
      id: fields['id'].toString(),
      name: fields['nombre'].toString(),
      address: fields['direccion'].toString(),
      phone: fields['telefono'].toString(),
      email: fields['email'].toString(),
      latitude: fields['latitud'],
      longitude: fields['longitud'],
      provinces: [],
    );

    return contact;
  }
}

class Delegation {
  final String id;
  final String title;
  final String address;
  final String phone;

  Delegation({this.id, this.title, this.address, this.phone});

  factory Delegation.fromJson(Map<String, dynamic> json) {
    return Delegation(
      id: json['id'].toString(),
      title: json['title'].toString(),
      address: json['address'].toString(),
      phone: json['phone'].toString(),
    );
  }
}
