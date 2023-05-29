import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sindicatos/Model/Contact.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/User.dart';
import '../../Network/ContactCalls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final Future<List<Contact>> fetchContactFuture = fetchContact();

  Contact contact;
  List<Contact> listContacts;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initialPosition;

  @override
  void initState() {
    super.initState();

    fetchContactFuture.then((contacts) {
      print('aqui');

      print(contacts);
      setState(() {
        this.contact = contacts.first;
        this.listContacts = contacts;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _call() async {
    await launch('tel://${contact.phone}');
  }

  void _sendEmail() async {
    await launch('mailto:${contact.email}');
  }

  Future<Position> _getPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  _openLocation() async {
    if (this.contact.latitude == null || this.contact.longitude == null) {
      await launch('https://www.google.com/maps/@-34.60366823325016,-58.38154894493021,17z');
    }
    else {
      Position position;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: FutureBuilder<Position>(
                future: _getPosition(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    position = snapshot.data;
                    Navigator.pop(context);
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
          );
        }
      );

      await launch('https://www.google.com/maps?saddr=${position.latitude},${position.longitude}&daddr=${contact.latitude},${contact.longitude}&dir_action=navigate');
    }
  }


  Future<void> _changePosition() async {
    final GoogleMapController controller = await _controller.future;
    LatLng _target;
    if (this.contact.latitude == null || this.contact.longitude == null) {
      _target = LatLng(-34.60444, -58.38322);
    } else {
      _target = LatLng(this.contact.latitude, this.contact.longitude);
    }
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _target, zoom: 17.0)));
  }

  _getContent() {
    List<Widget> listWidgets = [];

    listWidgets.add(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 1),
            )
          ],
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: 25.0),
        child: Column(children: <Widget>[
          _getMapBox(),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: Text(this.contact == null ? '' : this.contact.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: Text(
                          this.contact == null
                              ? ''
                              : this.contact.address +
                                  '\n' 'Mail: ' +
                                  this.contact.email +
                                  '\n',
                          style: TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                          maxLines: 15,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Color(0XFF8e9264),
                      onPressed: () => _openLocation(),
                      child: Text('Cómo Llegar',
                          style: TextStyle(color: Colors.white, fontSize: 11.0),
                          textAlign: TextAlign.center),
                    ),
                  )
                ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 130.0,
                margin: EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Color(0XFF8e9264),
                  onPressed: () => _call(),
                  child: Text(
                    'Llamar',
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Container(
                width: 130.0,
                margin: EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Color(0XFF8e9264),
                  onPressed: () => _sendEmail(),
                  child: Text(
                    'Email',
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15.0,
          )
        ])));
    listWidgets.add(Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Delegaciones:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0)),
          SizedBox(width: MediaQuery.of(context).size.width * 0.04),
          Container(
            height: 30.0,
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0, style: BorderStyle.solid, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.5,
            child: DropdownButton<String>(
              underline: Container(
                  decoration:
                      BoxDecoration(border: Border(bottom: BorderSide.none))),
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              value: contact.name,
              onChanged: (newValue) {
                for (Contact cont in this.listContacts) {
                  if (cont.name == newValue) {
                    setState(() {
                      this.contact = cont;
                      _changePosition();
                    });
                  }
                }
              },
              items: this
                  .listContacts
                  .map<DropdownMenuItem<String>>((Contact value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      value.name,
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.w500),
                      maxLines: 1,
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    ));

    listWidgets.add(SizedBox(
      height: 20,
    ));

    return listWidgets;
  }

  _getMapBox() {
    Marker _sindicatosMarker;
    if (this.contact.latitude == null || this.contact.longitude == null) {
      _initialPosition =
          CameraPosition(target: LatLng(-34.6044, -58.38322), zoom: 17);
      _sindicatosMarker = Marker(
        markerId: MarkerId('Sindicato'),
        // infoWindow: InfoWindow(title: 'Sindicato'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(-34.59981, -58.37279),
      );
    } else {
      _initialPosition = CameraPosition(
          target: LatLng(this.contact.latitude, this.contact.longitude),
          zoom: 17);
      _sindicatosMarker = Marker(
        markerId: MarkerId('Sindicatos'),
        //infoWindow: InfoWindow(title: 'Sindicatos'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(this.contact.latitude, this.contact.longitude),
      );
    }
    return Row(
      children: <Widget>[
        InkWell(
            child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8788,
            height: 160.0,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
              markers: {_sindicatosMarker},
              gestureRecognizers: Set()
                ..add(
                    Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                ..add(Factory<ScaleGestureRecognizer>(
                    () => ScaleGestureRecognizer()))
                ..add(
                    Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                ..add(
                  Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                  ),
                ),
            ),
          ),
        ))
      ],
    );
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
        child: new Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Container(
                  decoration: new BoxDecoration(
                      color: Color(0XFF8e9264),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
                      )),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      PageHeader(
                        menuItem:
                            CustomMenuItem.get(CustomMenuItemType.contact, widget.user),
                      ),
                      SizedBox(height: 10.0)
                    ],
                  ),
                ),
              ),
              this.contact == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: ListView(
                          children: _getContent(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
