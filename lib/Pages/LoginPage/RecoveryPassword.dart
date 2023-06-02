import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sindicatos/config.dart';
import '../../Model/RegisterFormModel.dart';
import '../LoginPage/RegisterPage.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../LoginPage/LoginPage.dart';

class RecoveryPage extends StatefulWidget {
  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  Config config = new Config();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dniController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String date;

  bool buttonPressed = false;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
  }

  List<RegisterFormModel> _getListModels() {
    return [
      RegisterFormModel(
          title: 'Correo',
          icon: Icons.alternate_email,
          keyboardType: TextInputType.emailAddress,
          controller: emailController),
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

    // Validar si el campo de correo electrónico está vacío
    if (listModels[0].controller.text.isEmpty) {
      showToast('El Correo Electrónico es requerido');
      setState(() {
        showLoading = false;
      });
      return;
    }

    // Validar si el campo de correo electrónico es válido
    if (!isEmailValid(listModels[0].controller.text)) {
      showToast('El Correo Electrónico debe ser válido');
      setState(() {
        showLoading = false;
      });
      return;
    }

    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode({
      "email": listModels[0].controller.text,
      "reset_url":
          "http://uatre-recovery-password.s3-website-us-east-1.amazonaws.com",
    });
    print(headers);
    print(msg);

    await http
        .post(Uri.parse(config.url + '/auth/password/request'),
            headers: headers, body: msg)
        .then((response) async {
      print('Response${response.statusCode}');
      if (response.statusCode == 204 && [msg] != "") {
        print("Inicio Sesion");
        showToast(
            'Se enviará un correo electrónico para recuperar la contraseña');
        setState(() {
          showLoading = false;
        });
        Navigator.of(thisContext).push(new MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ));
      } else {
        setState(() {
          showLoading = false;
        });
        dynamic resp = json.decode(response.body);
        print('Response${resp}');
        print("Credenciales Inválidas ${resp["errors"][0]["message"]}");
        if (resp["errors"][0]["message"].toString() ==
            '"email" must be a valid email') {
          showToast('El Correo Electrónico debe ser válido');
        }
      }
    });
  }

// Función para verificar si el correo electrónico es válido
  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }


    
  //   await http
  //       .post(Uri.parse(config.url + '/auth/password/request'),
  //           headers: headers, body: msg)
  //       .then((response) async {
  //     print('Response${response.body}');
  //     if (response.statusCode == 200) {
  //       print("Inicio Sesion");
  //       showToast(
  //           'Se enviara un correo electronico a para recuperar la contraseña');
  //       setState(() {
  //         showLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         showLoading = false;
  //       });
  //       dynamic resp = json.decode(response.body);
  //       print('Response${resp}');
  //       print("Credenciales Invalidas ${resp["errors"][0]["message"]}");
  //       if (resp["errors"][0]["message"].toString() ==
  //           '"email" must be a valid email') {
  //         showToast('El Correo Electrónico debe ser valido');
  //       }
  //     }
  //   });
    
  // }

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

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: new Container(
          child: new Container(
              child: new Stack(
            children: <Widget>[
              Container(
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
                                  width:
                                      MediaQuery.of(context).size.height * 0.20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    verticalDirection: VerticalDirection.up,
                                    children: <Widget>[
                                      // Container(
                                      //   height:
                                      //       MediaQuery.of(context).size.height *
                                      //           0.20,
                                      //   width:
                                      //       MediaQuery.of(context).size.height *
                                      //           0.19,
                                      ClipRRect(
                                        // borderRadius: BorderRadius.circular(73),
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
                                    onTap: () {
                                      // _onPressButton(context);
                                    },
                                    child: ClipRRect(
                                      //borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                          height: 30.0,
                                          width: 120.0,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  38, 117, 153, 1)),
                                          child: Center(
                                            // child: showProgress
                                            //   ? CircularProgressIndicator()
                                            //   : Text('Tap me'),
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //     new MaterialPageRoute(
                                      //         builder:
                                      //             (BuildContext context) =>
                                      //                 RegisterPage()));
                                      Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  RegisterPage(),
                                              transitionDuration:
                                                  Duration(seconds: 0)));
                                    },
                                    child: ClipRRect(
                                      //borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                          height: 30.0,
                                          width: 120.0,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200),
                                          child: Center(
                                            // child: showProgress
                                            //   ? CircularProgressIndicator()
                                            //   : Text('Tap me'),
                                            child: Text(
                                              'Registro',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    38, 117, 153, 1),
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
                                padding: EdgeInsets.only(bottom: 200),
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    width: MediaQuery.of(context).size.width *
                                        0.80,
                                    height: 30.0,
                                    decoration: new BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        // color: Color(0XFF1e8e5e),
                                        borderRadius:
                                            new BorderRadius.circular(20.0)),
                                    child:
                                        ListView(children: _getForm(context))),
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
                                            color: Color.fromRGBO(
                                                38, 117, 153, 1)),
                                        child: Center(
                                          // child: showProgress
                                          //   ? CircularProgressIndicator()
                                          //   : Text('Tap me'),
                                          child: showLoading
                                              ? CircularProgressIndicator()
                                              : Text(
                                                  'Recuperar',
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
                              height: 10.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ])),
            ],
          )),
        ));
  }
}
