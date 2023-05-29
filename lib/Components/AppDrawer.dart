import 'package:flutter/material.dart';
import '../Model/CustomMenuItem.dart';
import '../Model/User.dart';
import '../UI/Utils/Colors.dart';
import '../Pages/ComplaintsPage/ComplaintsPage.dart';
import '../Model/Helper/DataSaver.dart';
import '../Pages/SplashPage/SplashPage.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // _callTelemedicina() {
  //   DataSaver dataSaver = DataSaver();
  //   dataSaver.getUser().then((userSaved) {
  //     if (userSaved.name != '') {
  //       fetchTelemedicine(userSaved).then((fetchedTelemedicine) {
  //         print(fetchedTelemedicine);
  //         launch(fetchedTelemedicine, forceSafariVC: false);
  //       }).catchError((error) {
  //         print('Error: $error');
  //       });
  //     }
  //   }).catchError((error) {
  //     print('Error: $error');
  //   });
  // }

  void _onTap(CustomMenuItem menuItem) {
    if (menuItem.title ==
        CustomMenuItem.get(CustomMenuItemType.complaints, widget.user).title) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ComplaintsPage(
                user: widget.user,
              )));
      // }else if(menuItem.title == MenuItem.get(MenuItemType.telemedicine, widget.user).title){
      //   _callTelemedicina();
      // } else if (menuItem.title ==
      //     MenuItem.get(MenuItemType.virtualCredential, widget.user).title) {
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (BuildContext context) => VirtualCredentialPage(
      //             user: widget.user,
      //           )));
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => menuItem.page));
    }
  }

  getDrawerMenuItem(BuildContext context, CustomMenuItem menuItem) {
    return new Container(
      decoration: BoxDecoration(color: Colors.grey[500]),
      child: Stack(
        children: <Widget>[
          new ListTile(
              title: new Text(
                menuItem.title,
                style: new TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              onTap: () => _onTap(menuItem)),
          Positioned(
              left: 10.0,
              right: 10.0,
              bottom: 0.0,
              child: Container(
                height: 1.0,
                color: Colors.white.withOpacity(0.2),
              ))
        ],
      ),
    );
  }

  getDrawerHeader(BuildContext context) {
    return DrawerHeader(
        decoration: new BoxDecoration(color: Colors.white),
        child: new Center(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Image(
                    height: 130.0,
                    width: 130.0,
                    image: AssetImage('assets/images/logo_icono.png')),
              ),
              Container(
                height: 40,
                width: 40,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              )
            ],
          ),
        ));
  }

  _closeSession() {
    print('Close session method called.');
    DataSaver dataSaver = DataSaver();
    dataSaver.removeUser().then((result) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => SplashPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: Colors.grey[500],
            child: Stack(
              children: <Widget>[
                ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          gradient: CustomTheme.getBackgroundGradient()),
                      child: getDrawerHeader(context),
                    ),
                    getDrawerMenuItem(
                        context,
                        CustomMenuItem.get(
                            CustomMenuItemType.homePage, widget.user)),
                    getDrawerMenuItem(
                        context,
                        CustomMenuItem.get(
                            CustomMenuItemType.history, widget.user)),
                    getDrawerMenuItem(
                        context,
                        CustomMenuItem.get(
                            CustomMenuItemType.nosotros, widget.user)),
                    getDrawerMenuItem(
                        context,
                        CustomMenuItem.get(
                            CustomMenuItemType.news, widget.user)),
                    getDrawerMenuItem(
                        context,
                        CustomMenuItem.get(
                            CustomMenuItemType.media, widget.user)),
                    getDrawerMenuItem(
                        context,
                        CustomMenuItem.get(
                            CustomMenuItemType.beneficts, widget.user)),
                    getDrawerMenuItem(
                        context,
                        CustomMenuItem.get(
                            CustomMenuItemType.prestamo, widget.user)),
                    getDrawerMenuItem(
                        context,
                        CustomMenuItem.get(
                            CustomMenuItemType.complaints, widget.user)),
                    getDrawerMenuItem(
                        context,
                        CustomMenuItem.get(
                            CustomMenuItemType.contact, widget.user)),

                    getDrawerMenuItem(
                        context,
                        CustomMenuItem.get(
                            CustomMenuItemType.delete, widget.user)),
                    // getDrawerMenuItem(
                    //     context,
                    //     MenuItem.get(
                    //         MenuItemType.virtualCredential, widget.user)),

                    // getDrawerMenuItem(context,
                    //     MenuItem.get(MenuItemType.nosotros, widget.user)),
                    Container(
                      height: 80.0,
                      color: Colors.grey[500],
                      margin: EdgeInsets.only(right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            child: Text(
                              'Cerrar Sesión',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            onTap: () => _closeSession(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )));
  }
}
