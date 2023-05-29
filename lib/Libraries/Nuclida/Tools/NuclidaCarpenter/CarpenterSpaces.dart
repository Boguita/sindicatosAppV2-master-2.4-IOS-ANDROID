import 'package:flutter/material.dart';
import '../../DataHandling/NuclidaConstants.dart';

class CarpenterSpaces {

    Widget getBlankSpace({
      double width, 
      double height,
      NuclidaOrientationType orientationType
    }) {
      return orientationType == NuclidaOrientationType.Horizontal 
        ? _buildHorizontalSimpleSpace(
          width: width, 
          height: height,
          lineType: NuclidaSimpleLineType.None
        )
        : _buildVerticalSimpleSpace(
          height: height, 
          width: width,
          lineType: NuclidaSimpleLineType.None
        )
      ;
    }

    Widget getLinedSpace({
      double width, 
      double height,
      NuclidaOrientationType orientationType, 
      NuclidaSimpleLineType lineType
    }) {
      return orientationType == NuclidaOrientationType.Horizontal 
        ? _buildHorizontalSimpleSpace(
          width: width, 
          height: height,
          lineType: lineType
        )
        : _buildVerticalSimpleSpace(
          height: height, 
          width: width,
          lineType: lineType
        )
      ;
    }

    Widget _buildHorizontalSimpleSpace({
      double width, 
      double height,
      NuclidaSimpleLineType lineType
    }) {
      double lineWidth = NuclidaConstants.getValueForLine(
        lineType: lineType
      );
      double eachSpaceWidth = ((width - lineWidth)/(2.toDouble()));
      return Container(
        width: width,
        height: height,
        child: Row(
          children: <Widget>[
            SizedBox(width: eachSpaceWidth,),
            Container(
              width: lineWidth,
              color: Colors.black87,
            ),
            SizedBox(width: eachSpaceWidth,),
          ],
        ),
      );
    }

    Widget _buildVerticalSimpleSpace({
      double height, 
      double width,
      NuclidaSimpleLineType lineType
    }) {
      double lineHeight = NuclidaConstants.getValueForLine(
        lineType: lineType
      );
      double eachSpaceHeight = ((height - lineHeight)/(2.toDouble()));
      return Container(
        height: height,
        width: width,
        child: Column(
          children: <Widget>[
            SizedBox(height: eachSpaceHeight,),
            Container(
              height: lineHeight,
              color: Colors.black87,
            ),
            SizedBox(height: eachSpaceHeight,),
          ],
        ),
      );
    }

}