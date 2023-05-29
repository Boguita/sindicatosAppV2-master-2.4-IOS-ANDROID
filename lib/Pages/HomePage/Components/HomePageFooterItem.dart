import 'package:flutter/material.dart';
import '../../../Model/CustomMenuItem.dart';

class HomePageFooterItem extends StatefulWidget {
  HomePageFooterItem({Key key, this.menuItem, this.alignment})
      : super(key: key);

  final CustomMenuItem menuItem;
  final MainAxisAlignment alignment;

  @override
  _HomePageFooterItemState createState() => _HomePageFooterItemState();
}

class _HomePageFooterItemState extends State<HomePageFooterItem> {
  Widget get assetComponent {
    return Container(
      width: 60,
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 60.0,
            height: 60.0,
            child: Image(
              image: widget.menuItem.icon,
              alignment: Alignment.center,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 150.0,
      decoration: new ShapeDecoration(
          shape: new RoundedRectangleBorder(
              side: BorderSide(width: 4.0, color: Colors.blue),
              borderRadius: widget.alignment == MainAxisAlignment.start
                  ? BorderRadius.only(
                      topRight: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0))
                  : BorderRadius.only(
                      topLeft: Radius.circular(60.0),
                      bottomLeft: Radius.circular(60.0)))),
      child: Row(
        mainAxisAlignment: widget.alignment,
        children: <Widget>[
          SizedBox(
            width: widget.alignment == MainAxisAlignment.start ? 10.0 : 0.0,
          ),
          widget.alignment == MainAxisAlignment.end
              ? assetComponent
              : SizedBox(
                  width: 0,
                ),
          Container(
            width: 90.0,
            child: Text(
              widget.menuItem.title,
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 15.0,
              ),
              textAlign: widget.alignment == MainAxisAlignment.start
                  ? TextAlign.left
                  : TextAlign.right,
            ),
          ),
          widget.alignment == MainAxisAlignment.start
              ? assetComponent
              : SizedBox(
                  width: 0,
                ),
          SizedBox(
            width: widget.alignment == MainAxisAlignment.end ? 10.0 : 0.0,
          )
        ],
      ),
    );
  }
}
