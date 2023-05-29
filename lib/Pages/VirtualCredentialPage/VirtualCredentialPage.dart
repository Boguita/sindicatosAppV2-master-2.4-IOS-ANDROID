import 'package:flutter/material.dart';
import 'package:sindicatos/Components/LoadingComponent.dart';
import 'package:sindicatos/Model/Helper/DataSaver.dart';
import 'package:sindicatos/config.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Components/LoadingComponent.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/User.dart';
import 'package:qr_flutter/qr_flutter.dart';

String urlImg = '';

class VirtualCredentialPage extends StatefulWidget {
  VirtualCredentialPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _VirtualCredentialPageState createState() => _VirtualCredentialPageState();
}

class _VirtualCredentialPageState extends State<VirtualCredentialPage> {
  Config config = new Config();
  String dataQR = '';
  String affiliatedNumber = '';
  String urlImg = '';

  @override
  void initState() {
    dataQR = '';

    dataQR =
        'Nombre Completo: ${widget.user.name} ${widget.user.lastName}\nDNI: ${widget.user.dni}\n Numero Afiliacion: ${widget.user.dni}';
    affiliatedNumber = '${widget.user.dni}';

    super.initState();

    _loadAffNumber();
  }

  void _loadAffNumber() async {
    DataSaver dS = DataSaver();
    await dS.getUser().then((userSaved) {
      setState(() {
        affiliatedNumber = userSaved.affiliated;
      });
    });
  }

  _getSection() {
    List<Widget> arrayOfItems = [];

    arrayOfItems.add(SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
    ));

    arrayOfItems.add(Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.16,
        width: MediaQuery.of(context).size.height * 0.16,
        // child: ClipRRect(
        //   borderRadius: BorderRadius.circular(75),
        //   child: Container(
        //     decoration: BoxDecoration(color: Colors.grey[300]),
        //     child: Container(
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(73),
        //         child: Container(
        //           child: FadeInImage(
        //               image: urlImg.isEmpty
        //                   ? AssetImage('assets/images/loading.gif')
        //                   : NetworkImage(urlImg),
        //               placeholder: AssetImage('assets/images/loading.gif'),
        //               fit: BoxFit.cover),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    ));

    arrayOfItems
        .add(SizedBox(height: MediaQuery.of(context).size.height * 0.01));

    arrayOfItems
        .add(SizedBox(height: MediaQuery.of(context).size.height * 0.01));

    arrayOfItems.add(Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Container(
            //   //margin: const EdgeInsets.symmetric(horizontal: 20),
            //   width: MediaQuery.of(context).size.height * 0.16,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     verticalDirection: VerticalDirection.up,
            //     children: <Widget>[
            //       // // Container(
            //       // //   height: MediaQuery.of(context).size.height * 0.16,
            //       // //   width: MediaQuery.of(context).size.height * 0.30,
            //       // //   child: ClipRRect(
            //       // //     borderRadius: BorderRadius.circular(75),
            //       // //     child: Container(
            //       // //       decoration: BoxDecoration(color: Colors.grey[300]),
            //       // //       child: Container(
            //       // //         child: ClipRRect(
            //       // //           borderRadius: BorderRadius.circular(90),
            //       // //           child: Container(
            //       // //             child: FadeInImage(
            //       // //                 image: urlImg.isEmpty
            //       // //                     ? AssetImage('assets/images/loading.gif')
            //       // //                     : NetworkImage(urlImg),
            //       // //                 placeholder:
            //       // //                     AssetImage('assets/images/loading.gif'),
            //       // //                 fit: BoxFit.cover),
            //       // //           ),
            //       // //         ),
            //       // //       ),
            //       // //     ),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              width: MediaQuery.of(context).size.height * 0.14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.up,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      onTap: null,
                      child: new QrImage(
                        data: dataQR,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ));
    arrayOfItems
        .add(SizedBox(height: MediaQuery.of(context).size.height * 0.04));
    arrayOfItems.add(Center(
      child: Text(
        '${widget.user.name} ${widget.user.lastName}',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800),
      ),
    ));

    arrayOfItems
        .add(SizedBox(height: MediaQuery.of(context).size.height * 0.01));
    arrayOfItems.add(Container(
      child: Text(
        'Afiliado N°: ' + '$affiliatedNumber',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
      ),
    ));
    return arrayOfItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 75),
        child: CustomAppBar(),
      ),
      drawer: new AppDrawer(
        user: widget.user,
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/fondoCredential.jpg'),
                fit: BoxFit.cover)),
        child: dataQR == ''
            ? LoadingComponent()
            : ListView(
                // padding: EdgeInsets.all(10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  StickyHeader(
                      header: Container(
                          decoration: new BoxDecoration(
                              color: Color(0XFF588157),
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(30.0),
                                topRight: const Radius.circular(30.0),
                              )),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              PageHeader(
                                menuItem: CustomMenuItem.get(
                                    CustomMenuItemType.virtualCredential,
                                    widget.user),
                                key: null,
                              ),
                              SizedBox(height: 10.0),
                            ],
                          )),
                      content: Container(
                          // height: MediaQuery.of(context).size.height * 0.50,
                          padding: EdgeInsets.all(30),
                          child: Container(
                              // padding: EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/credencial.png'),
                                      fit: BoxFit.fill)),
                              //width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.60,
                              child: Column(
                                children: _getSection(),
                              ))))
                ],
              ),
      ),
    );
  }
}
