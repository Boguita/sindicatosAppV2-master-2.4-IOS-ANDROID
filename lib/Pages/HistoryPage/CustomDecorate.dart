


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class Timeline extends StatefulWidget {
  
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> with SingleTickerProviderStateMixin {
 
  double _scaleFactor = 1.0;
  


  @override
  void initState() {
    super.initState();
    
  }
  

  @override
  void dispose() {
 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          setState(() {
            _scaleFactor = 1.0 + notification.scrollDelta / 200.0;
          });
        } else if (notification is ScrollEndNotification) {
          setState(() {
            _scaleFactor = 1.0;
          });
        }
        return false;
      },
     
    child: Transform.scale(
        scale: _scaleFactor,
        child: CustomPaint(
          painter: TimelinePainter(),
        ),
      ),
        );

  }
}


class TimelinePainter extends CustomPainter {


  void paint(Canvas canvas, Size size) {
    final double startY = 0.0;
    final double endY = 2000;

    final Offset start = Offset(size.width / 2, startY);
    final Offset end = Offset(size.width / 2, endY);

    // Dibujar la línea vertical
    final Paint linePaint = Paint()
      ..color = Color(0xFFD6D5D5)
      ..strokeWidth = 2.0;
    canvas.drawLine(start, end, linePaint);

  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) {
   return true;
  }
}
class CustomDecoratedBox extends StatefulWidget {
  final String year;
  final dynamic color;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomDecoratedBox({
    this.year,
    this.color,
    this.onTap,
    this.isSelected = false,
  });

  @override
  _CustomDecoratedBoxState createState() => _CustomDecoratedBoxState();
}

class _CustomDecoratedBoxState extends State<CustomDecoratedBox> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    double circleSize = 25.0;
    double fontSize = 18.0;
    double containerWidth = 310.0;
    double containerHeight = 60.0;

    if (isClicked || widget.isSelected) {
      fontSize *= 1.3;
      containerWidth *= 1.04;
      containerHeight *= 1.1;
    }

    return GestureDetector(
  onTap: () {
    setState(() {
      isClicked = !isClicked;
    });
  },
  child: Container(
    width: 380,
    child: Row(

      children: [
        Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: Offset(13,0),
            child:

      Timeline(),
          ),
        ),
        Stack (
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 30,
                      height: 30,
                      // height: double.infinity,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(widget.color),
                          width: isClicked || widget.isSelected ? 10 : 2,
                        ),
                        color: Color.fromARGB(255, 231, 231, 232),
                      ),
                      
                    ),
                  ),
                  
                ],
              ),
        Align( 
                  alignment: Alignment.bottomLeft,
                  child: Transform.translate(
                    offset: Offset(40.0, 35.0),
                    child: Transform.rotate(
                    angle: 12,
                    child: Container(
                    width: 30,
                    height: 50,
                    color: Color(widget.color).withOpacity(0.6),
                  ),
                  ),
                  ),
                ),
    
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500) ,
              height: containerHeight,
              width: containerWidth,
              
                decoration: BoxDecoration(
                color: Color(widget.color).withOpacity(1),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child:
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child:
              Text(
                        widget.year  ,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      ),
               ),
             
            ),
            
          ),
        ),
        
      ],
    ),
  ),
);
  }}