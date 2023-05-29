import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sindicatos/Components/LoadingComponent.dart';
import 'package:sindicatos/Model/nosotros.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/User.dart';
import '../../Network/NosotrosCalls.dart';
import '../../../Components/FullScreenUrl.dart';

class NosotrosPage extends StatefulWidget {
  NosotrosPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _NosotrosPageState createState() => _NosotrosPageState();
}

class _NosotrosPageState extends State<NosotrosPage> {
  final Future<List<Nosotros>> fetchNosotrosFuture = fetchNosotros();
  List<Nosotros> listNosotros;

  @override
  void initState() {
    super.initState();

    fetchNosotrosFuture.then((nosotrosList) {
      setState(() {
        listNosotros = nosotrosList;
      });
    });
  }

  _getNosotrosList() {
    List<Widget> contentCells = [];
    contentCells.add(SizedBox(height: 15.0));

    listNosotros = listNosotros.reversed.toList();

    if (listNosotros.length > 0) {
      for (var i = 0; i < listNosotros.length; i++) {
        print(listNosotros[i].preview.toString());
        contentCells.add(ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext contet) => FullScreenUrl(
                        imageUrl: listNosotros[i].preview.toString(),
                      )));
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Color(0XFF1d6ea3)),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                 Transform.scale(
  scale: 1, // Cambia el valor de escala según tus necesidades
  child: ClipOval(
    child: Container(
   
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: Color(0XFF1e6fa4),
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: listNosotros[i].preview.toString().length > 0
            ? NetworkImage(listNosotros[i].preview.toString())
            : AssetImage('assets/images/no-image.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    ),
  ),
),

                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 6.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            listNosotros[i].name,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            listNosotros[i].cargo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          child: Container(
                            child: Html(
                              data: '<div style=\"color: #FFFFFF;\">' +
                                  listNosotros[i].description +
                                  '</div>',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
        contentCells.add(SizedBox(
          height: 15.0,
        ));
      }
    }

    var cellsToShow = contentCells;

    return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          StickyHeader(
            header: Container(
                color: Color(0XFF185f91),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0XFF185f91),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
                      )),
                  child: Column(
                    children: <Widget>[
                      PageHeader(
                        menuItem: CustomMenuItem.get(
                            CustomMenuItemType.nosotros, widget.user),
                      ),
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
            padding: EdgeInsets.all(20),
            decoration: new BoxDecoration(
                color: Color(0XFF185f91),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                )),
            child: Column(children: <Widget>[
              Expanded(
                  child: listNosotros == null
                      ? LoadingComponent()
                      : _getNosotrosList()),
            ])));
  }
}
