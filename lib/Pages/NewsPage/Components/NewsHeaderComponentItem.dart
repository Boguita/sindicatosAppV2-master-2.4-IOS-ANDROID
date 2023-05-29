import 'package:flutter/material.dart';
import 'package:sindicatos/Libraries/Core.dart';
import '../../../Model/News.dart';
import '../NewsDetailPage.dart';

class NewsHeaderComponentItem extends StatefulWidget {
  NewsHeaderComponentItem({Key key, this.news}) : super(key: key);

  final News news;

  @override
  _NewsHeaderComponentItemState createState() =>
      _NewsHeaderComponentItemState();
}

class _NewsHeaderComponentItemState extends State<NewsHeaderComponentItem> {
  @override
  Widget build(BuildContext context) {
    // print(widget.news.imageUrl);

    return new Container(
      // margin: const EdgeInsets.only(top: 1.0, left: 12.0, right: 12.0),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => NewsDetailPage(
                      news: widget.news,
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
                        alignment: Alignment.topCenter,
                    image: widget.news.imageUrl.length > 0
                        ? NetworkImage(widget.news.imageUrl.first.video
                            ? widget.news.imageUrl.first.prevVideo
                            : widget.news.imageUrl.first.image)
                        : AssetImage('assets/images/no-image.jpg'),
                    fit: BoxFit.cover,
                  )),
                ),
                Container(
                  decoration: BoxDecoration(color: Color(0XFF56BED6)),
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
                                    Core.instance.formatDate(widget.news.date),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  widget.news.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8, bottom: 6),
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0)
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => NewsDetailPage(news: widget.news)
                                        )
                                      );
                                    },
                                    child: Text(
                                      'Leer [+]',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        color: Color(0xFF56BED6)
                                      )
                                    ),
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
