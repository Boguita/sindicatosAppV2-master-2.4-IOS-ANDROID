import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sindicatos/Components/FullScreenUrl.dart';
import 'package:sindicatos/config.dart';
import '../../Model/User.dart';
import './Components/HomeMenuItem.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Model/CustomMenuItem.dart' as MiModelo;
import 'package:http/http.dart' as http;
import 'package:new_version_plus/new_version_plus.dart';
import '../../Network/UpdateDialog.dart';


final config = new Config();

class HomePage extends StatefulWidget {
  HomePage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final separationInset = 15.0;

  bool functionExecuted = false;
  List<dynamic> menuAdd;
  List<Widget> staticMenu = [];
  List<Widget> dynamicMenu = [];
  List<Widget> endMenu = [];

  @override
  void initState() {
 
    iniciarMenu();

    super.initState();
    final newVersion = NewVersionPlus(
      androidId: 'com.galgo.uatre',
      iOSId: 'com.galgo.uatre',
    );
    
    Timer(const Duration(milliseconds: 3000), () {
      checkNewVersion(newVersion);
    });
  }

   void checkNewVersion(NewVersionPlus newVersion) async {
    try {
      final status = await newVersion.getVersionStatus();
      if (status != null) {        
          if(status.canUpdate) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return UpdateDialog(
                  allowDismissal: true,
                  description: status.releaseNotes ?? '',
                  version: status.storeVersion,
                  appLink: status.appStoreLink,
                );
              },
            );
          }        
        debugPrint(status.releaseNotes);
        debugPrint(status.appStoreLink);
        debugPrint(status.localVersion);
        debugPrint(status.storeVersion);
        debugPrint(status.appStoreLink);
        debugPrint(status.canUpdate.toString());
      }
    } catch (error) {
      print(error);
    }
  }

  iniciarMenu() {
    http
        .get(Uri.parse(config.url + '/items/MenuDinamico'))
        .then((response) async {
      setState(() {
        dynamic result = json.decode(response.body);
        menuAdd = result['data'];
        print('menuAddo: $menuAdd');
        print('menuAddo: ${menuAdd[1]['status']}');
        _getMenu();
        _getMenuAdditional();
      });
    });
  }

   

  Future<void> _loadData() async {
    iniciarMenu();
  }

  _getMenu() {
    staticMenu = [];
    staticMenu.add(HomeMenuItem(
        menuItem: MiModelo.CustomMenuItem.get(
            MiModelo.CustomMenuItemType.history, widget.user),
        user: widget.user));
    staticMenu.add(HomeMenuItem(
        menuItem: MiModelo.CustomMenuItem.get(
            MiModelo.CustomMenuItemType.nosotros, widget.user),
        user: widget.user));
    staticMenu.add(HomeMenuItem(
        menuItem: MiModelo.CustomMenuItem.get(
            MiModelo.CustomMenuItemType.news, widget.user),
        user: widget.user));
    staticMenu.add(HomeMenuItem(
        menuItem: MiModelo.CustomMenuItem.get(
            MiModelo.CustomMenuItemType.media, widget.user),
        user: widget.user));
    staticMenu.add(HomeMenuItem(
        menuItem: MiModelo.CustomMenuItem.get(
            MiModelo.CustomMenuItemType.beneficts, widget.user),
        user: widget.user));
    staticMenu.add(HomeMenuItem(
        menuItem: MiModelo.CustomMenuItem.get(
            MiModelo.CustomMenuItemType.prestamo, widget.user),
        user: widget.user));

    // listMenu.add(HomeMenuItem(
    //     menuItem: MenuItem.get(MenuItemType.virtualCredential, widget.user),
    //     user: widget.user));
  }

  _getMenuAdditional() {
    dynamicMenu = [];
    for (int i = 0; i < menuAdd.length; i++) {
      if (menuAdd[i]['status'] == true && menuAdd[i]['titulo'].length > 0) {
        dynamicMenu.add(InkWell(
          onTap: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext contet) => FullScreenUrl(
                      imageUrl: menuAdd[i]['url'],
                    )));
          },
          child: Container(
            height: 145,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.brown),
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: NetworkImage(
                      config.url + "/assets/" + menuAdd[i]['Icono']),
                      alignment: Alignment.center,
                       height: 60,
                ),
                SizedBox(height: 20),
                Text(
                  menuAdd[i]['titulo'] != null ? menuAdd[i]['titulo'] : '',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ));
      }
    }

    endMenu = [];
    endMenu.add(HomeMenuItem(
        menuItem: MiModelo.CustomMenuItem.get(
            MiModelo.CustomMenuItemType.complaints, widget.user),
        user: widget.user));
    endMenu.add(HomeMenuItem(
        menuItem: MiModelo.CustomMenuItem.get(
            MiModelo.CustomMenuItemType.contact, widget.user),
        user: widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 75),
        child: CustomAppBar(),
      ),
      backgroundColor: Color(0xffEFEFEF),
      drawer: AppDrawer(user: widget.user),
      body: RefreshIndicator(
          // trigger the _loadData function when the user pulls down
          onRefresh: _loadData,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 15),
            children: [
              SizedBox(height: 15),
              GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 0),
                shrinkWrap: true,
                itemCount: staticMenu.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) => GestureDetector(child: staticMenu[index]),
              ),
              dynamicMenu.length > 0 ? 
              ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15),
                shrinkWrap: true,
                itemCount: dynamicMenu.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => GestureDetector(child: dynamicMenu[index]),
              ) : const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                itemCount: endMenu.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) => GestureDetector(child: endMenu[index]),
              ),
              const SizedBox(height: 15),
            ],
          )),
    );
  }
}
