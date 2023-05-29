import 'package:flutter/material.dart';
import 'package:sindicatos/Components/LoadingComponent.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Model/BenefictItem.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/User.dart';
import './BenefictsItemPage.dart';
import '../../Network/BenefictCalls.dart';

class BenefictsPage extends StatefulWidget {
  BenefictsPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _BenefictsPageState createState() => _BenefictsPageState();
}

class _BenefictsPageState extends State<BenefictsPage> {
  final Future<List<BenefictItem>> fetchBenefictsFuture = fetchBeneficts();
  List<BenefictItem> benefictItems = [];

  @override
  void initState() {
    super.initState();

    fetchBenefictsFuture.then((benefictsList) {
      setState(() {
        benefictItems = benefictsList;
      });
    });
  }

  _getBenefictsList() {
    List<Widget> contentCells = [];
    contentCells.add(SizedBox(height: 15.0));
    benefictItems = benefictItems.reversed.toList();

    if (benefictItems.length > 0) {
      for (var i = 0; i < benefictItems.length; i++) {
        contentCells.add(Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => BenefictsItemPage(
                              user: widget.user,
                              benefict: benefictItems[i],
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      //width: MediaQuery.of(context).size.width * 0.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          height: 150.0,
                          decoration: BoxDecoration(color: Color(0XFF2ba06b)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ClipRRect(
                                child: Container(
                                  // height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                          image: benefictItems[i].icon.length >
                                                  0
                                              ? NetworkImage(
                                                  benefictItems[i].icon.first)
                                              : AssetImage(
                                                  'assets/images/no-image.jpg'),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 14.0),
                                  child: Text(
                                    benefictItems[i].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ));
      }
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
                    color: Color(0XFF1e8e5e),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0),
                    )),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    PageHeader(
                      menuItem:
                         CustomMenuItem.get(CustomMenuItemType.beneficts, widget.user),
                    ),
                    SizedBox(height: 10.0)
                  ],
                ),
              ),
            ),
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
            decoration: new BoxDecoration(
                color: Color(0XFF1e8e5e),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                )),
            child: Column(children: <Widget>[
              Expanded(
                  child: benefictItems.length == 0
                      ? LoadingComponent()
                      : _getBenefictsList()),
            ])));
  }
}
