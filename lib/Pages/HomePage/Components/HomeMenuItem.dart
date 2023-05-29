import 'package:flutter/material.dart';
import '../../../Model/CustomMenuItem.dart';
import '../../../Model/User.dart';
import '../../ComplaintsPage/ComplaintsPage.dart';
import '../../../Model/Helper/DataSaver.dart';
import '../../../Network/TelemedicineCalls.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeMenuItem extends StatefulWidget {
  HomeMenuItem({Key key, this.menuItem, this.user}) : super(key: key);

  final CustomMenuItem menuItem;
  final User user;

  @override
  _HomeMenuItemState createState() => _HomeMenuItemState();
}

class _HomeMenuItemState extends State<HomeMenuItem> {
  _callTelemedicina() async {
    DataSaver dataSaver = DataSaver();
    dataSaver.getUser().then((userSaved) async {
      if (userSaved.name != '') {
        fetchTelemedicine(userSaved).then((fetchedTelemedicine) {
          launch(fetchedTelemedicine, forceSafariVC: false);
        }).catchError((error) {
          print('Error: $error');
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  _pressMenuItem(BuildContext context) {
    print(widget.user);

    if (widget.menuItem.title ==
        CustomMenuItem.get(CustomMenuItemType.complaints, widget.user).title) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ComplaintsPage(
                user: widget.user,
              )));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => widget.menuItem.page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      child: InkWell(
        onTap: () => _pressMenuItem(context),
        child: Container(
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: widget.menuItem.color),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: widget.menuItem.icon,
                height: 60.0,
              ),
              SizedBox(height: 20.0),
              Text(
                widget.menuItem.title,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
