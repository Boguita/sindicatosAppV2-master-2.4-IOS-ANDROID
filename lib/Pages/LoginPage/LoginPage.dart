import 'dart:convert'; // import 'dart:html';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sindicatos/Libraries/Core.dart';
import 'package:sindicatos/Libraries/PathConstants.dart';
import 'package:sindicatos/Libraries/responsive.dart';
import 'package:sindicatos/Network/push_notification_service.dart';
import 'package:sindicatos/config.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../UI/Utils/Colors.dart';
import '../../Model/RegisterFormModel.dart';
import '../../Model/User.dart';
import '../HomePage/HomePage.dart';
import '../LoginPage/RegisterPage.dart';
import '../../Model/Helper/DataSaver.dart';
import '../../Model/CustomMenuItem.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:directus/directus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'RecoveryPassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Config config = new Config();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dniController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  // File _imageUploaded;
  String date;

  bool buttonPressed = false;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    
  }

 

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();

    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
  }

  List<RegisterFormModel> _getListModels() {
    return [
      RegisterFormModel(
          title: 'Correo',
          icon: Icons.alternate_email,
          keyboardType: TextInputType.emailAddress,
          controller: emailController),
      RegisterFormModel(
          title: 'Contraseña',
          icon: Icons.vpn_key,
          keyboardType: TextInputType.visiblePassword,
          controller: phoneController),
    ];
  }

  void _onPressButton(BuildContext thisContext) async {
    dynamic resp2;
    setState(() {
      buttonPressed = true;
    });
    setState(() {
      showLoading = true;
    });
    List<RegisterFormModel> listModels = _getListModels();

    for (var i = 0; i < listModels.length - 1; i++) {
      print('CHECK: ${listModels[i].title}');
      if (listModels[i].controller.text != null) {
        if (listModels[i].controller.text.isEmpty) {
          print('Error');
          setState(() {
            showLoading = false;
          });
          return;
        } else {
          print('CHECK OK: ${listModels[i].title}');
        }
      } else {
        print('CHECK OK: ${listModels[i].title}');
      }
    }

    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode({
      "email": listModels[0].controller.text,
      "password": listModels[1].controller.text
    });
    await http
        .post(Uri.parse(config.url + '/auth/login'),
            headers: headers, body: msg)
        .then((response) async {
      print('Response${response.statusCode}');
      if (response.statusCode == 200) {
        print("Inicio Sesion");
        dynamic resp = json.decode(response.body);
        print('Response${resp}');
        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + resp["data"]["access_token"]
        };

        await http
            .get(Uri.parse(config.url + '/users/me'), headers: headers)
            .then((response2) async {
          print("Inicio Sesion");
          resp2 = json.decode(response2.body);
           refreshToken(resp2['data']['id']);
          print('Response${resp2}');
        });
        DataSaver dataSaver = DataSaver();
        
        dataSaver.saveUser(UserSaved(
            name: resp2["data"]["first_name"],
            lastName: resp2["data"]["last_name"],
            dni: resp2["data"]["dni"],
            email: resp2["data"]["email"],
            affiliated: resp2["data"]["dni"],
            id: resp2['data']['id']));
        Navigator.of(thisContext).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => HomePage(
              user: User(
                  name: resp2["data"]["first_name"],
                  lastName: resp2["data"]["last_name"],
                  dni: resp2["data"]["dni"],
                  email: resp2["data"]["email"],
                  id: resp2["data"]["id"]),
              key: null,
            ),
          ),
        );
      } else {
        setState(() {
          showLoading = false;
        });
        dynamic resp = json.decode(response.body);
        print('Response${resp}');
        showToast("Credenciales Invalidas");
        if (resp["errors"][0]["message"].toString() ==
            '"email" must be a valid email') {
          showToast('El Correo Electrónico debe ser valido');
        }
      }
    });
  }

  void refreshToken(id) async {
  String token = await PushNotificationService.getToken();
  Map<String, String> headers = {'Content-Type': 'application/json'};
  final msg = jsonEncode({
    "token_firebase": token
  });
  
  await http.patch(Uri.parse(config.url + '/Users/$id'), headers: headers, body: msg).then((response) async {
    if (response.statusCode == 200) {
      // La actualización del token se ha realizado con éxito
      print('Token de Firebase actualizado en la base de datos');
    }
  });
}

  _getTextfield(RegisterFormModel model) {
    if (model.keyboardType == TextInputType.datetime) {
      return DateTimeField(
        format: DateFormat("dd/MM/yyyy"),
        decoration: InputDecoration(
          prefixIcon: Icon(
            model.icon,
            color: Color.fromRGBO(38, 117, 153, 1),
          ),
          border: InputBorder.none,
          hintText: model.title,
          hintStyle: TextStyle(
              color: (buttonPressed && date == null)
                  ? Colors.red
                  : Color.fromRGBO(145, 205, 235, 1),
              fontWeight: FontWeight.w600,
              fontSize: 16.0),
          labelText: 'Fecha de Nacimiento',
          labelStyle: TextStyle(
              color: (buttonPressed && date == null)
                  ? Colors.red
                  : Color.fromRGBO(145, 205, 235, 1),
              fontWeight: FontWeight.w600,
              fontSize: 16.0),
        ),
        keyboardType: model.keyboardType,
        style: TextStyle(
            color: Color.fromRGBO(145, 205, 235, 1),
            fontWeight: FontWeight.w600,
            fontSize: 16.0),
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              locale: const Locale("es", ""),
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            return DateTimeField.combine(
                date, TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
          } else {
            return currentValue;
          }
        },
        onChanged: (dt) {
          setState(() {
            date = '${dt.year}-${dt.month}-${dt.day}';
          });
          dateController.text = date;
          print('Selected date: $dt');
        },
      );
    }

    return TextField(
      controller: model.controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          model.icon,
          color: Color.fromRGBO(38, 117, 153, 1),
        ),
        border: InputBorder.none,
        hintText: model.title,
        hintStyle: TextStyle(
            color: (buttonPressed && model.controller.text.isEmpty)
                ? Colors.red
                : Color.fromRGBO(145, 205, 235, 1),
            fontSize: 16.0,
            fontWeight: FontWeight.w600),
      ),
      autocorrect: false,
      obscureText: model.controller == phoneController ? true : false,
      keyboardType: model.keyboardType,
      style: TextStyle(color: Color.fromRGBO(38, 117, 153, 1), fontSize: 16.0),
    );
  }

  void showToast(mensaje) => Fluttertoast.showToast(
        msg: mensaje,
        fontSize: 18,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

  _getForm(BuildContext context) {
    List<RegisterFormModel> listModels = _getListModels();
    List<Widget> widgets = [];

    for (var i = 0; i < listModels.length; i++) {
      widgets.add(_getTextfield(listModels[i]));
      widgets.add(Divider(
        color: Color.fromRGBO(38, 117, 153, 1),
        height: 1.0,
      ));
      widgets.add(SizedBox(
        height: 20.0,
      ));
    }
    widgets.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: InkWell(
          child: Text(
            "Recuperar Contraseña",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 12.0,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => RecoveryPage()));
          },
        ),
      ),
    );

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
              height: responsive.getHeightPercentage(100.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/fondo3.png'),
                      fit: BoxFit.cover)),
              child: new Stack(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              width: MediaQuery.of(context).size.height * 0.20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                verticalDirection: VerticalDirection.up,
                                children: <Widget>[
                                  ClipRRect(
                                    child: Container(
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/logo.png'),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            verticalDirection: VerticalDirection.up,
                            children: <Widget>[
                              InkWell(
                                onTap: () {},
                                child: Container(
                                    height: 30.0,
                                    width: 120.0,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(38, 117, 153, 1)),
                                    child: Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              RegisterPage(),
                                          transitionDuration:
                                              Duration(seconds: 0)));
                                },
                                child: ClipRRect(
                                  child: Container(
                                      height: 30.0,
                                      width: 120.0,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200),
                                      child: Center(
                                        child: Text(
                                          'Registro',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(38, 117, 153, 1),
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(bottom: 100),
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                width: MediaQuery.of(context).size.width * 0.80,
                                height: 30.0,
                                decoration: new BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue,
                                    ),
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                child: ListView(children: _getForm(context))),
                          ),
                        ),
                        Container(
                            child: Column(
                          verticalDirection: VerticalDirection.up,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _onPressButton(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                    height: 50.0,
                                    width: 180.0,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(38, 117, 153, 1)),
                                    child: Center(
                                      child: showLoading
                                          ? CircularProgressIndicator()
                                          : Text(
                                              'Ingresar',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                    )),
                              ),
                            )
                          ],
                        )),
                        SizedBox(
                          height: 35.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ])),
        ));
  }
}
