import 'package:shared_preferences/shared_preferences.dart';

class UserSaved {
  final String name;
  final String lastName;
  final String dni;
  final String email;
  final String phone;
  final String birthdate;
  final String image;
  final String affiliated;
  final String id;

  UserSaved(
      {this.name,
      this.lastName,
      this.dni,
      this.email,
      this.phone,
      this.birthdate,
      this.image,
      this.affiliated,
      this.id});
}

class DataSaver {
  //User
  static var key_name = 'key_name';
  static var key_lastName = 'key_lastName';
  static var key_dni = 'key_dni';
  static var key_email = 'key_email';
  static var key_phone = 'key_phone';
  static var key_birthdate = 'key_birthdate';
  static var key_image = 'key_image';
  static var key_affiliated = 'key_affiliated';
  static var key_id = 'key_id';

  Future<UserSaved> getUser() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();

    return UserSaved(
        name: sharedPref.getString(DataSaver.key_name) ?? '',
        lastName: sharedPref.getString(DataSaver.key_lastName) ?? '',
        dni: sharedPref.getString(DataSaver.key_dni) ?? '',
        email: sharedPref.getString(DataSaver.key_email) ?? '',
        phone: sharedPref.getString(DataSaver.key_phone) ?? '',
        birthdate: sharedPref.getString(DataSaver.key_birthdate) ?? '',
        image: sharedPref.getString(DataSaver.key_image) ?? '',
        affiliated: sharedPref.getString(DataSaver.key_affiliated) ?? '',
        id: sharedPref.getString(DataSaver.key_id) ?? '');
  }

  Future<bool> removeUser() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    bool removeName = await sharedPref.remove(DataSaver.key_name);
    bool removeLastName = await sharedPref.remove(DataSaver.key_lastName);
    bool removeDNI = await sharedPref.remove(DataSaver.key_dni);
    bool removeEmail = await sharedPref.remove(DataSaver.key_email);
    bool removePhone = await sharedPref.remove(DataSaver.key_phone);
    bool removeBirthdate = await sharedPref.remove(DataSaver.key_birthdate);
    bool removeImage = await sharedPref.remove(DataSaver.key_image);
    bool removeAffil = await sharedPref.remove(DataSaver.key_affiliated);
    bool removeId = await sharedPref.remove(DataSaver.key_id);

    return removeName &&
        removeLastName &&
        removeDNI &&
        removeEmail &&
        removePhone &&
        removeBirthdate &&
        removeImage &&
        removeAffil &&
        removeId;
  }

  Future<bool> saveUser(UserSaved userSaved) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();

    bool saveName =
        await sharedPref.setString(DataSaver.key_name, userSaved.name);
    bool saveLastName =
        await sharedPref.setString(DataSaver.key_lastName, userSaved.lastName);
    bool saveDNI = await sharedPref.setString(DataSaver.key_dni, userSaved.dni);
    bool saveEmail =
        await sharedPref.setString(DataSaver.key_email, userSaved.email);
    // bool savePhone = await sharedPref.setString(DataSaver.key_phone, userSaved.phone);
    // bool saveBirthdate = await sharedPref.setString(DataSaver.key_birthdate, userSaved.birthdate);
    // bool saveImage = await sharedPref.setString(DataSaver.key_image, userSaved.image);
    bool saveAff = await sharedPref.setString(
        DataSaver.key_affiliated, userSaved.affiliated);
    bool saveId = await sharedPref.setString(DataSaver.key_id, userSaved.id);

    return saveName &&
        saveLastName &&
        saveDNI &&
        saveEmail &&
        // savePhone &&
        // saveBirthdate &&
        saveId &&
        saveAff;
  }
}
