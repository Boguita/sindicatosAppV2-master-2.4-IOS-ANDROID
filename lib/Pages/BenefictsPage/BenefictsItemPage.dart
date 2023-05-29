import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sindicatos/Components/LoadingComponent.dart';
import 'package:sindicatos/Network/BenefictCalls.dart';
import 'package:sindicatos/config.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Model/BenefictItem.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/User.dart';
import './BenefictDetail.dart';

final config = new Config();

class BenefictsItemPage extends StatefulWidget {
  BenefictsItemPage({Key key, this.user, this.benefict}) : super(key: key);

  final User user;
  final BenefictItem benefict;

  @override
  _BenefictsItemPageState createState() => _BenefictsItemPageState();
}

class _BenefictsItemPageState extends State<BenefictsItemPage> {
  List<dynamic> benefictItem = [];

  @override
  void initState() {
    final Future<List<dynamic>> fetchBenefictFuture =
        fetchBenefict(widget.benefict.id);

    super.initState();

    fetchBenefictFuture.then((benefictList) {
      setState(() {
        benefictItem = benefictList;
      });
    });
  }

  _getBenefictsList() {
    print(benefictItem);
    List<Widget> initialCells = [];
    List<Widget> contentCells = [];

    if (benefictItem.length > 0) {
      List<dynamic> benefList = benefictItem;

      initialCells.add(Container(
          color: Colors.white,
          child: Container(
            decoration: new BoxDecoration(
                color: Color(0XFF1e8e5e),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                )),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                PageHeader(
                  menuItem: CustomMenuItem.get(
                      CustomMenuItemType.beneficts, widget.user),
                ),
                SizedBox(height: 10.0)
              ],
            ),
          )));
      initialCells.add(Container(
        color: Color(0XFF2ba06b),
        child: Row(
          children: <Widget>[
            SizedBox(width: 20.0),
            Expanded(
              child: Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                  child: Text(benefictItem[0]['category']['nombre'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),
      ));
      contentCells.add(SizedBox(
        height: 8.0,
      ));
      if (benefList.length > 0) {
        for (int i = 0; i < benefList.length; i++) {
          BenefictDetail _benefInt = BenefictDetail.fromJson(benefList[i]);
          print(_benefInt);
          contentCells.add(InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => BenefictDetailPage(
                      benefict: _benefInt,
                      category: benefictItem[0]['category']['nombre'])));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0XFF1e8e5e),
              ),
              margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 180.0,
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0)),
                          color: Colors.white,
                          image: DecorationImage(
                            image: (_benefInt.media.length > 0)
                                ? NetworkImage(_benefInt.media.first.video
                                    ? _benefInt.media.first.prevVideo
                                    : _benefInt.media.first.image)
                                : AssetImage(
                                    'assets/images/no-image.jpg'),
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(_benefInt.title,
                        textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis),
                    )),
                  ]),
            ),
          ));
        }
      }
    }

    var cellsToShow = contentCells;

    return ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          StickyHeader(
            header: Column(children: initialCells),
            content: Column(children: cellsToShow),
          ),
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
            child: Column(children: <Widget>[
          Expanded(
              child: benefictItem.length == 0
                  ? LoadingComponent()
                  : _getBenefictsList()),
        ])));
  }
}
