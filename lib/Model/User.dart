class User {
  final String id;
  final String name;
  final String lastName;
  final String dni;
  final String email;
  final String phone;
  final String birthdate;
  final String image;

  User(
      {this.id,
      this.name,
      this.lastName,
      this.dni,
      this.email,
      this.phone,
      this.birthdate,
      this.image});

  setId(int id) {
    id = id;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> fields = json;

    User user = User(
      id: fields['id'].toString(),
      name: fields['nombre'].toString(),
      lastName: fields['apellido'].toString(),
      dni: fields['dni'].toString(),
      birthdate: fields['fechaDeNacimiento'].toString(),
      email: fields['email'].toString(),
      phone: fields['telefono'].toString(),
      image: fields['imagen'].toString(),
    );

    return user;
  }
}
