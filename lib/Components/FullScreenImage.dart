import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FullScreenImage extends StatefulWidget {
  FullScreenImage({Key key, this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
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
                    child: widget.imageUrl.contains('youtu')
                        ? WebView(
                            initialUrl: widget.imageUrl,
                            javascriptMode: JavascriptMode.unrestricted,
                          )
                        : ClipRect(
                            child: PhotoView(
                              imageProvider: NetworkImage(widget.imageUrl),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        )));
  }
}
