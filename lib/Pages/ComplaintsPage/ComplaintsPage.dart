import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sindicatos/Pages/HomePage/HomePage.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/User.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:sindicatos/config.dart';

final config = new Config();
// File _imageUploaded = null;
bool buttonPressed = false;

class ComplaintsPage extends StatefulWidget {
  ComplaintsPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController provinciaController = TextEditingController();
  TextEditingController localidadController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController complaintController = TextEditingController();
  File _imageUploaded = null;
  void _sendComplaint() async {
    String idImage;
    if (complaintController.text.isEmpty) {
      return;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Denuncia'),
              content: new Text(
                  'Muchas gracias por su denuncia, será procesada a la brevedad.'),
              actions: <Widget>[
                new TextButton(
                  child: new Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HomePage(
                              user: widget.user,
                              key: null,
                            )));
                  },
                )
              ],
            );
          });
    }

     var stream;
    var length;

    if (_imageUploaded != null) {
      stream = new http.ByteStream(
          DelegatingStream.typed(_imageUploaded.openRead()));
      length = await _imageUploaded.length();
      var uri = Uri.parse(config.url + '/files');

      var request = new http.MultipartRequest("POST", uri);

      request.fields['ref'] = "Denuncia";
      request.fields['field'] = "Imagen";

      var multipartFile = new http.MultipartFile(
        'files',
        stream,
        length,
        filename: Path.basename(_imageUploaded.path),
        contentType: new MediaType('image', 'png'),
      );

      request.files.add(multipartFile);

      var responseUpd = await request.send();
      print(responseUpd.statusCode);

      responseUpd.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        dynamic responseData = json.decode(value);
        idImage = responseData['data']['id'];
        print(idImage);

        var user = widget.user.id;

        String iduser = user;
        print('iduser $iduser');

        Map<String, dynamic> map = {
          'provincia': provinciaController.text,
          'localidad': localidadController.text,
          'denuncia': complaintController.text,
          'miembros': iduser,
          'imagen': idImage,
        };
        String jsonBody = json.encode(map);
        final response = await http.post(
          Uri.parse(config.url + '/items/denuncias'),
          headers: {'Content-Type': 'application/json'},
          body: jsonBody,
        );

        dynamic result = json.decode(response.body);
        print('Result $result');
      });
    } else {
      var user = widget.user.id;

      String iduser = user;
      print('iduser $iduser');

      Map<String, dynamic> map = {
        'provincia': provinciaController.text,
        'localidad': localidadController.text,
        'denuncia': complaintController.text,
        'miembros': iduser,
        'imagen':
            null, // Establece la imagen como nula si no se seleccionó ninguna
      };
      String jsonBody = json.encode(map);
      final response = await http.post(
        Uri.parse(config.url + '/items/denuncias'),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      dynamic result = json.decode(response.body);
      print('Result $result');
    }
  }

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();

    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _imageUploaded = File(image.path);
    });
  }

  @override
  void initState() {
    super.initState();

    emailController.text = widget.user.email;
    nameController.text = widget.user.name + " " + widget.user.lastName;
    lastNameController.text = widget.user.lastName;
    phoneNumberController.text = widget.user.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 75),
        child: CustomAppBar(),
      ),
      // backgroundColor: Color(0xFFa98467),
      drawer: new AppDrawer(
        user: widget.user,
      ),
      body: new Container(
        decoration: new BoxDecoration(
            color: Color(0XFFe4a010),
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(30.0),
              topRight: const Radius.circular(30.0),
            )),
        child: new Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                    color: Color(0XFFe4a010),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0),
                    )),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    PageHeader(
                      menuItem:
                          CustomMenuItem.get(CustomMenuItemType.complaints, widget.user),
                    ),
                    SizedBox(height: 10.0)
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18.0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20.0),
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 8.0),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.76,
                                          height: 40,
                                          color: Colors.white,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Center(
                                              child: TextField(
                                                enabled: false,
                                                controller: nameController,
                                                style: new TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                decoration:
                                                    InputDecoration.collapsed(
                                                  hintText: 'Nombre',
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 10.0,
                                ),
                                SizedBox(width: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.76,
                                          height: 40,
                                          color: Colors.white,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Center(
                                              child: TextField(
                                                enabled: false,
                                                controller: emailController,
                                                style: new TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                decoration:
                                                    InputDecoration.collapsed(
                                                  hintText: 'CORREO',
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 10.0,
                                ),
                                SizedBox(width: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.76,
                                          height: 40,
                                          color: Colors.white,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Center(
                                              child: TextField(
                                                // enabled: false,
                                                controller: provinciaController,
                                                style: new TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                decoration:
                                                    InputDecoration.collapsed(
                                                  hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
                                                  hintText: 'Provincia',
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 10.0,
                                ),
                                SizedBox(width: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.76,
                                          height: 40,
                                          color: Colors.white,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Center(
                                              child: TextField(
                                                // enabled: false,
                                                controller: localidadController,
                                                style: new TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                decoration:
                                                    InputDecoration.collapsed(
                                                  hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
                                                  hintText: 'Localidad',
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 10.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none,
                                      hintText: _imageUploaded != null
                                          ? 'Foto subida.'
                                          : 'Subir foto',
                                      hintStyle: TextStyle(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.w600,
                                          fontSize: 16.0),
                                    ),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      // fontWeight: FontWeight.w600,
                                    ),
                                    enabled: false,
                                    autocorrect: false,
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.76,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, top: 12.0),
                                            child: Center(
                                              child: TextField(
                                                style: new TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                controller: complaintController,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                  hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
                                                  hintText:
                                                      'Escriba aquí su denuncia',
                                                ),
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 6,
                                                // maxLength: 1000,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 1.0,
                                ),
                                SizedBox(
                                  height: 25.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0.0),
                            child: Container(
                              height: 50,
                              width: 240.0,
                              child: MaterialButton(
                                color: Colors.white,
                                child: Text(
                                  'Enviar',
                                  style: new TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () => _sendComplaint(),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
