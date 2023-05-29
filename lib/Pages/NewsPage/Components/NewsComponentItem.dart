import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sindicatos/Libraries/Core.dart';
import '../../../Model/News.dart';
import '../../../Model/CustomMenuItem.dart';
import '../../../Model/User.dart';
import '../NewsDetailPage.dart';

class NewsComponentItem extends StatefulWidget {
  NewsComponentItem({Key key, this.user, this.news}) : super(key: key);

  final User user;
  final News news;

  @override
  _NewsComponentItemState createState() => _NewsComponentItemState();
}

class _NewsComponentItemState extends State<NewsComponentItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      //card
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => NewsDetailPage(news: widget.news)
              )
            );
          },
          child: Container(
            decoration: BoxDecoration(color: Color(0xFF56BED6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //image
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                          image: widget.news.imageUrl.length > 0
                              ? NetworkImage(widget
                                      .news.imageUrl.first.video
                                  ? widget.news.imageUrl.first.prevVideo
                                  : widget.news.imageUrl.first.image)
                              : AssetImage('assets/images/no-image.jpg'),
                          fit: BoxFit.cover
                        )
                      ),
                  ),
                ),
                //text
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //text
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6, left: 10.0, right: 10.0, bottom: 6.0),
                                child: Text(
                                  Core.instance.formatDate(widget.news.date),
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
                                widget.news.title,
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
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => NewsDetailPage(news: widget.news)
                                  )
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)
                              ),
                              child: Text(
                                'Leer [+]',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  color: Color(0xFF56BED6)
                                )
                              )
                            ),
                        ),
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

  //renderizar Html
  Widget shortDescription() {
    String htmlData = widget.news.shortDescription;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Container(
          height: 48.0,
          child: Markdown(
            data: htmlData,
          ),
        ));
  }
}
