import 'package:flutter/material.dart';
import 'package:sindicatos/Libraries/Core.dart';
import '../../../Model/Media.dart';
import '../../../Components/FullScreenUrl.dart';

class MediaHeaderComponentItem extends StatefulWidget {
  MediaHeaderComponentItem({Key key, this.media}) : super(key: key);

  final Media media;

  @override
  _MediaHeaderComponentItemState createState() =>
      _MediaHeaderComponentItemState();
}

class _MediaHeaderComponentItemState extends State<MediaHeaderComponentItem> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ClipRRect(
        child: InkWell(
          onTap: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext contet) => FullScreenUrl(
                      imageUrl: widget.media.link,
                    )));
          },
          child: Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: widget.media.preview.length > 0
                        ? NetworkImage(widget.media.preview.first)
                        : AssetImage('assets/images/no-image.jpg'),
                  )),
                ),
                Container(
                  decoration: BoxDecoration(color: Color(0XFF3a5b40)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 12.0),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    Core.instance.formatDate(widget.media.date),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.white
                                      ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Container(
                                  child: Text(
                                  widget.media.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0, bottom: 6.0),
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext contet) => FullScreenUrl(imageUrl: widget.media.link)
                                        )
                                      );
                                    },
                                    child: Text(
                                      'Ver [+]',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                          color: Color(0XFF3a5b40)
                                      )
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0)
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
