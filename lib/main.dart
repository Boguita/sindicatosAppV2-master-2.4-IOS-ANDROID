import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sindicatos/Network/NewsCalls.dart';
import 'package:sindicatos/Network/push_notification_service.dart';
import 'package:sindicatos/Pages/NewsPage/NewsDetailPage.dart';
import './UI/Utils/Colors.dart';
import './Pages/HomePage/HomePage.dart';
import './Pages/SplashPage/SplashPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'Components/FullScreenUrl.dart';
import 'Model/News.dart';
import 'Pages/BenefictsPage/BenefictDetail.dart';
import 'Pages/MediaPage/MediaPage.dart';
import 'Pages/NewsPage/NewsPage.dart';
import '../../Network/BenefictCalls.dart';
import '../../Model/BenefictItem.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


  await PushNotificationService.initializeApp();
  
  
  runApp(MyApp());
}

List<News> listNews = [];
List<BenefictItem> listBenefits = [];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
      

  @override
  void initState() {
    super.initState();   
    

    PushNotificationService.messagesStream.listen((message) {
      if (message['category'] == 'Noticia') {
        News noti;

        fetchNews.then((value) => {
              setState(() {
                listNews = value;
              }),
              noti = listNews
                  .where((element) => element.id == message['categoryId'])
                  .toList()
                  .first,
              navigatorKey.currentState
                  ?.pushNamed('NewsPageDetail', arguments: noti)
            });
      } else if (message['category'] == 'Multimedia') {
        navigatorKey.currentState?.pushNamed('MediaPage');
      } else if (message['category'] == 'Url') {
        String imageUrl = message['categoryId'];
        navigatorKey.currentState
            ?.pushNamed('FullScreenUrl', arguments: imageUrl);
      } else if (message['category'] == 'Beneficio') {
        dynamic beneficio;
        fetchBenefictId(int.parse(message['categoryId'])).then((value) => {
              setState(() {
                beneficio = value;
              }),
              navigatorKey.currentState
                  ?.pushNamed('BenefictDetailPage', arguments: beneficio)
            });
      } else {
        navigatorKey.currentState?.pushNamed('Menu');
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomThemeData,
      home: SplashPage(),      
      navigatorKey: navigatorKey, // Navegar
      scaffoldMessengerKey: messengerKey, // Snacks
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
      ],
      routes: {
        'NewsPage': (_) => NewsPage(),
        'NewsPageDetail': (_) => NewsDetailPage(),
        'MediaPage': (_) => MediaPage(),
        'FullScreenUrl': (_) => FullScreenUrl(),
        'BenefictDetailPage': (_) => BenefictDetailPage(),
        'Menu': (_) => HomePage()
      },
    );
  }
}