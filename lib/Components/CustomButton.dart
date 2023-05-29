import 'package:flutter/material.dart';

enum CustomButtonStyle { blueBackground, whiteBackground }

class CustomButton extends StatefulWidget {
  CustomButton({Key key, this.title, this.action, this.style})
      : super(key: key);

  final Function action;
  final String title;
  final CustomButtonStyle style;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  Color backgroundColor;
  Color fontColor;

  @override
  void initState() {
    super.initState();

    setState(() {
      switch (widget.style) {
        case CustomButtonStyle.blueBackground:
          backgroundColor = Color.fromARGB(255, 83, 149, 184);
          fontColor = Colors.white;
          break;
        case CustomButtonStyle.whiteBackground:
          backgroundColor = Colors.white;
          fontColor = Colors.blue[400];
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.action,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17.5),
        child: Container(
          height: 35.0,
          width: 90.0,
          decoration: new BoxDecoration(color: backgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                    color: fontColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
