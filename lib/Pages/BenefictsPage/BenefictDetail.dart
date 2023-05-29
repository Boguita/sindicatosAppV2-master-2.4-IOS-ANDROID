import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:html/dom.dart' as dom;
import 'package:sindicatos/Components/FullScreenUrl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sindicatos/Model/ImageNews.dart';
import 'package:sindicatos/config.dart';

import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';

import '../../Model/CustomMenuItem.dart';
import '../../Model/User.dart';

import '../../Components/FullScreenImage.dart';

import '../../Model/GoogleLocationHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final config = new Config();
dynamic beneficio;

class BenefictDetailPage extends StatefulWidget {
  BenefictDetailPage({Key key, this.user, this.benefict, this.category})
      : super(key: key);
  final User user;
  final dynamic benefict;
  final String category;
  @override
  _BenefictDetailPageState createState() => _BenefictDetailPageState();
}

class _BenefictDetailPageState extends State<BenefictDetailPage> {
  final accessToken =
      'pk.eyJ1IjoiY2FjaXF1ZWFwcCIsImEiOiJjanVkM3M2MG4wM2EyNDRteXR1ZDNyaDFvIn0.Izn2mc3SFHRfDs1vU7Vy0A';

  Completer<GoogleMapController> _controller = Completer();

  Future<GoogleLocationHelper> fetchLocation() async {
    String searchText = Uri.encodeFull(beneficio.location);
    print(searchText);

    final response = await http.get(Uri.parse(
        'https://api.opencagedata.com/geocode/v1/geojson?q=$searchText&key=5207209b5d054b45b1202cd6e8e9a111&pretty=1'));

    if (response.statusCode == 200) {
      GoogleLocationHelper helper =
          GoogleLocationHelper.fromJson(json.decode(response.body));
      print(helper.coordinates);
      return helper;
    } else {
      throw Exception('Failed to load google location helper');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _getMapBox() {
    CameraPosition _initialPosition;
    Marker _sindicatosMarker;

    if (beneficio.latitude == null || beneficio.longitude == null) {
      _initialPosition =
          CameraPosition(target: LatLng(7.7686935, -72.2147347), zoom: 14);
      _sindicatosMarker = Marker(
        markerId: MarkerId('Sindicatos'),
        infoWindow: InfoWindow(title: 'Sindicatos'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(7.7686935, -72.2147347),
      );
    } else {
      _initialPosition = CameraPosition(
          target: LatLng(beneficio.longitude, beneficio.latitude), zoom: 17);

      _sindicatosMarker = Marker(
        markerId: MarkerId('Sindicatos'),
        //infoWindow: InfoWindow(title: 'Sindicatos'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(beneficio.longitude, beneficio.latitude),
      );
    }

    LatLng coordinates = LatLng(7.768639, -72.214135);
    return InkWell(
        onTap: () async {
          String link = 'http://www.google.com/maps/place/' +
              coordinates.latitude.toString() +
              ',' +
              coordinates.longitude.toString();
          await launch(link);
        },
        child: Container(
          height: 220,
          decoration: BoxDecoration(color: Colors.white),
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
            markers: {_sindicatosMarker},
            gestureRecognizers: Set()
              ..add(Factory<PanGestureRecognizer>(
                  () => PanGestureRecognizer()))
              ..add(Factory<ScaleGestureRecognizer>(
                  () => ScaleGestureRecognizer()))
              ..add(Factory<TapGestureRecognizer>(
                  () => TapGestureRecognizer()))
              ..add(
                Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer(),
                ),
              ),
          ),
        ));
  }

  _getBenefict() {
    return InkWell(
        child: ClipRRect(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 500.0,
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  ],
                ),
              ))
            ],
          )),
    ));
  }

  _getContent() {
    List<Widget> listWidgets = [];

    listWidgets.add(_getBenefict());
    listWidgets.add(_getMapBox());

    return listWidgets;
  }

  _getListOfImages(List<ImageNews> imagesUrls) {
    List<Widget> imageUrlWidgets = [];

    for (var j = 0; j < imagesUrls.length; j++) {
      imageUrlWidgets.add(InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => FullScreenImage(
                    imageUrl: imagesUrls[j].image,
                  )));
        },
        child: Container(
          width: (MediaQuery.of(context).size.width * 0.97),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Image(
              image: imagesUrls[j] == null
                  ? AssetImage('assets/images/placeholderImage.jpg')
                  : NetworkImage(imagesUrls[j].video
                      ? imagesUrls[j].prevVideo
                      : imagesUrls[j].image),
              fit: BoxFit.fill),
        ),
      ));
    }

    return imageUrlWidgets;
  }

  _getCarousel(List<ImageNews> imagesUrls) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        child: CarouselSlider(
          options: CarouselOptions(
            height: 230,
            viewportFraction: 1,
            enlargeCenterPage: true
          ),
          items: _getListOfImages(imagesUrls)
        )
      )
    );
  }

  Future<Position> _getPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  _openLocation() async {
    if (beneficio.latitude == null || beneficio.longitude == null) {
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

      await launch('https://www.google.com/maps?saddr=${position.latitude},${position.longitude}&daddr=${beneficio.longitude},${beneficio.latitude}&dir_action=navigate');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments ?? 'No data';
    beneficio = widget.benefict != null ? widget.benefict : args;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 75),
        child: CustomAppBar(),
      ),
      backgroundColor: Colors.white,
      drawer: AppDrawer(user: widget.user),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            //beneficios bar
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                  color: Color(0XFF1e8e5e),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    topRight: const Radius.circular(30.0),
                  )),
              child: PageHeader(
                menuItem: CustomMenuItem.get(CustomMenuItemType.beneficts, widget.user),
              ),
            ),
            //tipo de beneficio
            Container(
              width: MediaQuery.of(context).size.height,
              color: Color(0XFF2ba06b),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                widget.category != null
                  ? widget.category
                  : beneficio.category,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700
                )
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //carousel
                      _getCarousel(
                        widget.benefict != null && widget.benefict.media != null
                          ? widget.benefict.media
                          : beneficio.media
                      ),
                      const SizedBox(height: 10.0),
                      //title
                      Text(
                        beneficio.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black
                        ),
                      ),
                      //descripcion
                      Html(
                        data: beneficio.description,
                        onLinkTap: (src,
                            RenderContext contextd,
                            Map<String, String> attributes,
                            dom.Element element) async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext contet) =>
                                  FullScreenUrl(imageUrl: src)));
                        },
                      ),
                      //buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: MaterialButton(
                                color: Color(0XFF2ba06b),
                                onPressed: () async {
                                  await launch('mailto:${beneficio.mail}');
                                },
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                          ),
                          Container(
                            child: MaterialButton(
                                color: Color(0XFF2ba06b),
                                onPressed: _openLocation,
                                child: Text(
                                  'Ubicación',
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5.0),
                            child: MaterialButton(
                                color: Color(0XFF2ba06b),
                                onPressed: () async {
                                  await launch('tel://${beneficio.phone}');
                                },
                                child: Text(
                                  'Llamar',
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      //map
                      _getMapBox(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
