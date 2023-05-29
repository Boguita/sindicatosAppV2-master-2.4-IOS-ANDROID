import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Components/LoadingComponent.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/News.dart';
import '../../Model/User.dart';
import './Components/NewsComponentItem.dart';
import './Components/NewsHeaderComponentItem.dart';
import '../../Network/NewsCalls.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final Future<dynamic> fetchNewsFuture = fetchNews;
  List<News> listNews;

  @override
  void initState() {
    super.initState();

    fetchNews.then((newsList) {
      setState(() => listNews = newsList);
    });
  }

  _getNewsList() {
  List<Widget> contentCells = [];

  if (listNews.length > 0) {
    contentCells.add(
      NewsHeaderComponentItem(
        news: News(
          id: listNews.first.id,
          title: listNews.first.title,
          imageUrl: listNews.first.imageUrl,
          shortDescription: listNews.first.shortDescription,
          content: listNews.first.content,
          date: listNews.first.date
        )
      )
    );

    contentCells.add(
      SizedBox(height: 8.0)
    );

    if (listNews.length > 1) {
      for (var i = 1; i < listNews.length; i++) {
        contentCells.add(
          NewsComponentItem(
            news: News(
              id: listNews[i].id,
              title: listNews[i].title,
              imageUrl: listNews[i].imageUrl,
              shortDescription: listNews[i].shortDescription,
              content: listNews[i].content,
              date: listNews[i].date
            ),
            user: widget.user
          )
        );
      }
    }
  }
  else {
    contentCells.add(Text('Vacio'));
    contentCells.add(SizedBox(height: 20.0));
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
                    color: Color(0XFF56BED6),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0),
                    )),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    PageHeader(
                      menuItem: CustomMenuItem.get(CustomMenuItemType.news, widget.user),
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
      backgroundColor: Colors.white,
      drawer: new AppDrawer(
        user: widget.user,
      ),
      body: new Container(
        color: Colors.white,
        child: new Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  child:
                      listNews == null ? LoadingComponent() : _getNewsList()),
            ],
          ),
        ),
      ),
    );
  }
}
