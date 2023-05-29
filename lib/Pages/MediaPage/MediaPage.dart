import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Components/LoadingComponent.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/Media.dart';
import '../../Model/User.dart';
import './Components/MediaComponentItem.dart';
import './Components/MediaHeaderComponentItem.dart';
import '../../Network/MediaCalls.dart';

class MediaPage extends StatefulWidget {
  MediaPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  final Future<List<Media>> fetchMediaFuture = fetchMedia();
  List<Media> listMedia;

  @override
  void initState() {
    super.initState();

    fetchMediaFuture.then((mediaList) {
      setState(() => listMedia = mediaList);
    });
  }

  _getMediaList() {
  List<Widget> contentCells = [];

  if (listMedia.length > 0) {
    contentCells.add(
      MediaHeaderComponentItem(media: listMedia.last)
    );

    if (listMedia.length > 1) {
      for (var i = listMedia.length - 2; i >= 0; i--) {
        contentCells.add(
          MediaComponentItem(
            media: listMedia[i],
            user: widget.user
          )
        );
      }
    }
  } else {
    contentCells.add(Text('Vacio'));
    contentCells.add(SizedBox(height: 10.0));
  }

  var cellsToShow = contentCells;

  return ListView(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        StickyHeader(
          header: Container(
              color: Colors.white,
              child: Container(
                decoration: new BoxDecoration(
                    color: Color(0XFF3a5b40),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0),
                    )),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    PageHeader(
                      menuItem: CustomMenuItem.get(CustomMenuItemType.media, widget.user),
                      key: null,
                    ),
                    SizedBox(height: 10.0)
                  ],
                ),
              )),
          content: Column(children: cellsToShow),
        )
      ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 75),
        child: CustomAppBar(),
      ),
      //backgroundColor: Colors.blue[700],
      backgroundColor: Colors.white,
      drawer: new AppDrawer(
        user: widget.user,
      ),
      body: new Container(
          color: Colors.white,
          child: new Container(
              child: Column(children: <Widget>[
            Expanded(
                child:
                    listMedia == null ? LoadingComponent() : _getMediaList()),
          ]))),
    );
  }
}
