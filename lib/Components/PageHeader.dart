import 'package:flutter/material.dart';
import '../Model/CustomMenuItem.dart';

class PageHeader extends StatefulWidget {
  PageHeader({Key key, this.menuItem}) : super(key: key);

  final CustomMenuItem menuItem;

  @override
  _PageHeaderState createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 25.0,
              ),
              Image(
                width: 32,
                height: 32,
                //image: AssetImage('assets/images/menuLeftBackIcon.png'),
                image: widget.menuItem.icon,
                //color: widget.menuItem.color,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.menuItem.title,
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 5.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
