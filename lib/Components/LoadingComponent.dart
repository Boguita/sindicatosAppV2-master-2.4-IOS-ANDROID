import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(),
      ),
    );
  }

}