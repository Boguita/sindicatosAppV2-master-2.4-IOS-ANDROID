import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        centerTitle: true,
        leading: Builder(
            builder: (context) => SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: IconButton(
                    padding: new EdgeInsets.fromLTRB(22.0, 24.0, 0.0, 0.0),
                    icon: new Icon(
                      Icons.menu,
                      color: Colors.grey[600],
                      size: 38.0,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                )),
        backgroundColor: Colors.white,
        elevation: 0,
        // brightness: Brightness.light,
        title: Container(
          margin: EdgeInsets.only(top: 18.0),
          child: new Image.asset('assets/images/logo_icono.png',
              fit: BoxFit.contain, height: 38.0),
        ),
      ),
    );
  }
}
