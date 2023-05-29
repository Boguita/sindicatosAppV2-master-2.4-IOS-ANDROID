import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:sindicatos/Libraries/responsive.dart';
import 'package:sindicatos/Network/push_notification_service.dart';
import 'package:sindicatos/config.dart';
import '../../Model/RegisterFormModel.dart';
import '../LoginPage/LoginPage.dart';
import '../../Model/Helper/DataSaver.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Config config = new Config();
  DataSaver dataSaver = DataSaver();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dniController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController phoneControllerCtrl = TextEditingController();
  TextEditingController dateController = TextEditingController();
  File _imageUploaded;
  String date;

  bool buttonPressed = false;
  bool showLoading = false;
  bool passCoinciden = true;

  @override
  void initState() {
    super.initState();

    // Mixpanel mixPanel = Mixpanel(
    //   token: "1ddb83798f663f2cfb1f870e6d1b0b8e",
    //   debug: false,
    //   trackIp: true,
    //   showDebugLog: true
    // );

    // mixPanel.track("Login");
  }

  // void httpJob(AnimationController controller) async {
  //   controller.forward();
  //   print("delay start");
  //   await Future.delayed(Duration(seconds: 3), () {});
  //   print("delay stop");
  //   controller.reset();
  // }

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();

    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _imageUploaded = File(image.path);
    });
  }

  String validatePassword(String value) {
    print("valorrr $value passsword ${phoneController.text}");
    if (value != phoneController.text) {
      return "Las contraseñas no coinciden";
    }
    return null;
  }

  List<RegisterFormModel> _getListModels() {
    return [
      RegisterFormModel(
          title: 'Nombre',
          icon: Icons.person,
          keyboardType: TextInputType.text,
          controller: nameController),
      RegisterFormModel(
          title: 'Apellido',
          icon: Icons.person,
          keyboardType: TextInputType.text,
          controller: lastNameController),
      RegisterFormModel(
          title: 'DNI',
          icon: Icons.person,
          keyboardType: TextInputType.number,
          controller: dniController),
      RegisterFormModel(
          title: 'Email',
          icon: Icons.alternate_email,
          keyboardType: TextInputType.emailAddress,
          controller: emailController),
      RegisterFormModel(
          title: 'Contraseña',
          icon: Icons.vpn_key,
          keyboardType: TextInputType.visiblePassword,
          controller: phoneController),
      RegisterFormModel(
          title: 'Repetir Contraseña',
          icon: Icons.vpn_key,
          keyboardType: TextInputType.visiblePassword,
          controller: phoneControllerCtrl)
    ];
  }

  void _onPressButton(BuildContext thisContext) async {
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
    if (listModels[4].controller.text != listModels[5].controller.text) {
      showToast("Su Contrasea no coinciden");
      passCoinciden = false;
      setState(() {
        showLoading = false;
      });
      return;
    }

    passCoinciden = true;

    String token = await PushNotificationService.getToken();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode({
      "email": listModels[3].controller.text,
      "password": listModels[4].controller.text,
      "role": "b62e7e87-8355-4d37-b781-3c81e9d19806",
      // "role": "ec696442-ef87-4ac3-a2c9-9d895779f812",
      "first_name": listModels[0].controller.text,
      "last_name": listModels[1].controller.text,
      "dni": listModels[2].controller.text,
      "token_firebase": token
    });
    await http
        .post(Uri.parse(config.url + '/Users'), headers: headers, body: msg)
        .then((response) async {
      print('Response${response.statusCode}');
      if (response.statusCode == 200) {
        print("Inicio Sesion");
        // dataSaver.saveUser(
        //   UserSaved(
        //       name: listModels[0].controller.text,
        //       lastName: listModels[1].controller.text,
        //       dni: listModels[2].controller.text,
        //       email: listModels[3].controller.text,
        //       affiliated: listModels[2].controller.text),
        // );
        showToast("Usuario Registrado Con Exito");
        Navigator.of(thisContext).push(new MaterialPageRoute(
            builder: (BuildContext context) => LoginPage()));
      } else {
        setState(() {
          showLoading = false;
        });
        dynamic resp = json.decode(response.body);
        print('Response${resp}');
        print("Credenciales Invalidas ${resp["errors"][0]["message"]}");
      }
    });
  }

  void showToast(mensaje) => Fluttertoast.showToast(
        msg: mensaje,
        fontSize: 18,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

  _uploadPhotoField() {
    return InkWell(
      onTap: () {
        getImage();
      },
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.camera_alt,
            color: Color.fromRGBO(38, 117, 153, 1),
          ),
          border: InputBorder.none,
          hintText: _imageUploaded != null ? 'Foto subida.' : 'Subir foto',
          hintStyle: TextStyle(
              color: (buttonPressed && _imageUploaded == null)
                  ? Colors.red
                  : Color.fromRGBO(145, 205, 235, 1),
              fontWeight: FontWeight.w600,
              fontSize: 16.0),
        ),
        style: TextStyle(
            color: Color.fromRGBO(145, 205, 235, 1),
            fontWeight: FontWeight.w600,
            fontSize: 16.0),
        enabled: false,
        autocorrect: false,
      ),
    );
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
            // final time = await showTimePicker(
            //   context: context,
            //   initialTime:
            //       TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            // );
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
          color: (buttonPressed &&
                  !passCoinciden &&
                  (model.title == "Contraseña" ||
                      model.title == "Repetir Contraseña"))
              ? Colors.red
              : Color.fromRGBO(38, 117, 153, 1),
        ),
        border: InputBorder.none,
        hintText: model.title,
        hintStyle: TextStyle(
            color: (buttonPressed && model.controller.text.isEmpty ||
                    (model.title == "Contraseña" && !passCoinciden))
                ? Colors.red
                : Color.fromRGBO(145, 205, 235, 1),
            fontSize: 16.0,
            fontWeight: FontWeight.w600),
      ),
      autocorrect: false,
      obscureText: model.controller == phoneController
          ? true
          : model.controller == phoneControllerCtrl
              ? true
              : false,
      keyboardType: model.keyboardType,
      style: TextStyle(
          color: (buttonPressed &&
                  !passCoinciden &&
                  (model.title == "Contraseña" ||
                      model.title == "Repetir Contraseña"))
              ? Colors.red
              : Color.fromRGBO(38, 117, 153, 1),
          fontSize: 16.0),
    );
  }

  _getForm(BuildContext context) {
    List<RegisterFormModel> listModels = _getListModels();
    List<Widget> widgets = [];

    // widgets.add(
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Container(
    //         margin: const EdgeInsets.symmetric(horizontal: 10),
    //         width: MediaQuery.of(context).size.height * 0.16,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           verticalDirection: VerticalDirection.up,
    //           children: <Widget>[
    //             Container(
    //               height: MediaQuery.of(context).size.height * 0.16,
    //               width: MediaQuery.of(context).size.height * 0.16,
    //               child: ClipRRect(
    //                 // borderRadius: BorderRadius.circular(75),
    //                 child: Container(
    //                   // decoration: BoxDecoration(color: Colors.grey[300]),
    //                   child: Container(
    //                     child: ClipRRect(
    //                       // borderRadius: BorderRadius.circular(73),
    //                       child: Container(
    //                         child: Image(
    //                             image: AssetImage('assets/images/logo.png'),
    //                             fit: BoxFit.cover),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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

    // widgets.add(_uploadPhotoField());
    // widgets.add(Divider(
    //   color: Color.fromRGBO(38, 117, 153, 1),
    //   height: 1.0,
    // ));

    // widgets.add(SizedBox(
    //   height: 20,
    // ));

    // widgets.add(
    //   Container(
    //       child: Column(
    //     verticalDirection: VerticalDirection.up,
    //     children: <Widget>[
    //       InkWell(
    //         onTap: () {
    //           _onPressButton(context);
    //         },
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(30),
    //           child: Container(
    //               height: 50.0,
    //               width: 180.0,
    //               decoration:
    //                   BoxDecoration(color: Color.fromRGBO(38, 117, 153, 1)),
    //               child: Center(
    //                 // child: showProgress
    //                 //   ? CircularProgressIndicator()
    //                 //   : Text('Tap me'),
    //                 child: showLoading
    //                     ? CircularProgressIndicator()
    //                     : Text(
    //                         'Ingresar',
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 16.0,
    //                         ),
    //                       ),
    //               )),
    //         ),
    //       )
    //     ],
    //   )),
    // );

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
              child: Container(
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
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    LoginPage(),
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
                                                'Login',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      38, 117, 153, 1),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            )),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: ClipRRect(
                                        child: Container(
                                            height: 30.0,
                                            width: 120.0,
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    38, 117, 153, 1)),
                                            child: Center(
                                              child: Text(
                                                'Registro',
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
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 30),
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    width: MediaQuery.of(context).size.width *
                                        0.80,
                                    decoration: new BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
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
                              height: 10.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]))),
        ));
  }
}
