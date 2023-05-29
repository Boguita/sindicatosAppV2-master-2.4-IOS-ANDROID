import 'package:flutter/material.dart';
import '../LoginPage/LoginPage.dart';
import '../../Model/Helper/DataSaver.dart';
import '../../Model/User.dart';
import '../../Pages/HomePage/HomePage.dart';
import 'dart:async';


class SplashPage extends StatefulWidget {
    const SplashPage({Key key}) : super(key: key);
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() { 

    super.initState();

    DataSaver dataSaver = DataSaver();

    dataSaver.getUser().then((userSaved) {
      if (userSaved.name != '') {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => HomePage(
                  user: User(
                      name: userSaved.name,
                      lastName: userSaved.lastName,
                      dni: userSaved.dni,
                      email: userSaved.email,
                      phone: userSaved.phone,
                      birthdate: userSaved.birthdate,
                      image: userSaved.image,
                      id: ''),
                  key: null,
                )));
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }
  
    
   
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash.png'),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 65.0),
            child: Center(
                child: Column(
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                        height: 50.0,
                        width: 180.0,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(38, 117, 153, 1)),
                        child: Center(
                          child: Text(
                            'Ingresar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        )),
                  ),
                ),
                SizedBox(height: 20)
              ],
            )),
          ),
        ));
  }
}
