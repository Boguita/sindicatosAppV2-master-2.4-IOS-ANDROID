import 'package:flutter/material.dart';
import 'package:sindicatos/Components/FullScreenUrl.dart';
import 'package:sindicatos/Libraries/Core.dart';
import 'package:sindicatos/Model/ImageNews.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/News.dart';
import '../../Model/User.dart';
import '../../Components/FullScreenImage.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class NewsDetailPage extends StatefulWidget {
  NewsDetailPage({Key key, this.user, this.news}) : super(key: key);

  final User user;
  final News news;

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  _getListOfImages(List<ImageNews> imagesUrls) {
    List<Widget> imageUrlWidgets = [];

    for (var j = 0; j < imagesUrls.length; j++) {
      imageUrlWidgets.add(InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext contet) => FullScreenImage(
                    imageUrl: imagesUrls[j].image,
                    key: null,
                  )));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Image(
            alignment: Alignment.topCenter,
            image: (imagesUrls[j] == null)
              ? AssetImage('assets/images/placeholderImage.jpg')
              : NetworkImage(imagesUrls[j].video
                  ? imagesUrls[j].prevVideo
                  : imagesUrls[j].image
                  ),
                  fit: BoxFit.fitWidth
            ),
        ),
      ));
    }

    return imageUrlWidgets;
  }

  _getCarousel(List<ImageNews> imagesUrls) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1.0,
                enlargeCenterPage: true,
              ),
              items: _getListOfImages(imagesUrls),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments ?? 'No data';
    News noticia = widget.news != null ? widget.news : args;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 75),
        child: CustomAppBar(),
      ),
      backgroundColor: Colors.white,
      drawer:  AppDrawer(
        user: widget.user,
      ),
      body:  SafeArea(
        child:  Container(
          decoration:  BoxDecoration(color: Colors.white),
          child:  Container(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    alignment: Alignment.center,
                    decoration:  BoxDecoration(
                        color: Color(0XFF56BED6),
                        borderRadius:  BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0),
                        )),
                    child: PageHeader(
                      menuItem: CustomMenuItem.get(CustomMenuItemType.news, widget.user),
                      key: null,
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 20.0,
                // ),
                Expanded(
                  child: Center(
                    // padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ListView(
                      children: <Widget>[
                        ClipRRect(
                          // borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _getCarousel(noticia.imageUrl),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10.0),
                                    child: Text(
                                      Core.instance.formatDate(noticia.date),
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(noticia.title,
                                        maxLines: 4,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Html(
                                        data: noticia.content,
                                        onLinkTap: (src,
                                            RenderContext contextd,
                                            Map<String, String> attributes,
                                            dom.Element element) async {
                                          //open URL in webview, or launch URL in browser, or any other logic here
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext contet) =>
                                                          FullScreenUrl(
                                                              imageUrl: src)));
                                        }),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
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
