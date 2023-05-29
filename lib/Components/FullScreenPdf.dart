import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FullScreenPdf extends StatefulWidget {
  FullScreenPdf({Key key, this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  _FullScreenPdfState createState() => _FullScreenPdfState();
}

class _FullScreenPdfState extends State<FullScreenPdf> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments ?? 'No data';
    return Scaffold(
        appBar: null,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Detalle',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 34,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Container(
                  height: 1.4,
                  decoration: BoxDecoration(color: Colors.black),
                ),
                Expanded(
                  child: Container(
                      child: WebView(
                    initialUrl: widget.imageUrl == null
                        ? args
                        : 'https://docs.google.com/viewer?url=${widget.imageUrl}',
                    javascriptMode: JavascriptMode.unrestricted,
                  )),
                )
              ],
            ),
          ),
        )));
  }
}
