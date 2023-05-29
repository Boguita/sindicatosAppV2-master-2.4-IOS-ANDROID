import 'package:flutter/material.dart';
import 'package:sindicatos/Libraries/Core.dart';
import '../../../Model/Media.dart';
import '../../../Components/FullScreenUrl.dart';
import '../../../Model/CustomMenuItem.dart';
import '../../../Model/User.dart';

class MediaComponentItem extends StatefulWidget {
  MediaComponentItem({Key key, this.user, this.media}) : super(key: key);

  final User user;
  final Media media;

  @override
  _MediaComponentItemState createState() => _MediaComponentItemState();
}

class _MediaComponentItemState extends State<MediaComponentItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      //card
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext contet) => FullScreenUrl(imageUrl: widget.media.link)
              )
            );
          },
          child: Container(
            decoration: BoxDecoration(color: Color(0XFF3a5b40)),
            child: Row(
              children: <Widget>[
                //image
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.topCenter,
                            image: widget.media.preview.length > 0
                                ? NetworkImage(widget.media.preview.first)
                                : AssetImage('assets/images/no-image.jpg'),
                            fit: BoxFit.cover)),
                  ),
                ),
                //text
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //text
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, top: 6.0, bottom: 6.0),
                                child: Text(
                                  Core.instance.formatDate(widget.media.date),
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                widget.media.title,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ),
                          ],
                        ),
                        //button
                        Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(right: 8.0, bottom: 6.0),
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
                                borderRadius: BorderRadius.circular(50.0))
                              ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
