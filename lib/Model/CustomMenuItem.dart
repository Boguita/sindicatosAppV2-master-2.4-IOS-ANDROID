import 'package:flutter/material.dart';
import 'package:sindicatos/Pages/LoanPage/LoanPage.dart';
import 'package:sindicatos/Pages/NosotrosPage/NosotrosPage.dart';
import '../Pages/HomePage/HomePage.dart';
import '../Pages/NewsPage/NewsPage.dart';
import '../Pages/HistoryPage/HistoryPage.dart';
import '../Pages/MediaPage/MediaPage.dart';
import '../Pages/ComplaintsPage/ComplaintsPage.dart';
import '../Pages/BenefictsPage/BenefictsPage.dart';
import '../Pages/ContactPage/ContactPage.dart';
import '../Pages/DeletePage/DeletePage.dart';
import '../Model/User.dart';

enum CustomMenuItemType {
  homePage,
  news,
  history,
  media,
  complaints,
  telemedicine,
  beneficts,
  virtualCredential,
  prestamo,
  contact,
  nosotros,
  delete
}

class CustomMenuItem {
  final String title;
  final Color color;
  final Widget page;
  final AssetImage icon;

  CustomMenuItem({this.title, this.color, this.page, this.icon});

  static CustomMenuItem get(CustomMenuItemType type, User user) {
    switch (type) {
      case CustomMenuItemType.homePage:
        // ignore: prefer_const_constructors
        return CustomMenuItem(
            title: 'Inicio',
            color: Color(0xFFF0A15E),
            page: HomePage(
              user: user,
              key: null,
            ),
            icon: null);
      case CustomMenuItemType.news:
        return CustomMenuItem(
            title: 'Noticias',
            color: Color(0XFF56BED6),
            page: NewsPage(user: user),
            icon: AssetImage('assets/images/iconNews.png'));
      case CustomMenuItemType.history:
        return CustomMenuItem(
            title: 'Historia',
            color: Color.fromRGBO(94, 160, 214, 1),
            page: HistoryPage(user: user),
            icon: AssetImage('assets/images/iconHistory.png'));
      case CustomMenuItemType.media:
        return CustomMenuItem(
            title: 'Multimedia',
            color: Color.fromRGBO(59, 90, 65, 1),
            page: MediaPage(user: user),
            icon: AssetImage('assets/images/iconMultimedia.png'));
      case CustomMenuItemType.complaints:
        return CustomMenuItem(
            title: 'Denuncias',
            color: Color(0XFFe4a010),
            page: ComplaintsPage(user: user),
            icon: AssetImage('assets/images/iconDenuncia.png'));
      // case MenuItemType.telemedicine:
      //   return MenuItem(
      //       title: 'Telemedicina',
      //       color: Color.fromRGBO(206, 168, 206, 1),
      //       page: null,
      //       icon: AssetImage('assets/images/iconTelemedicine.png'));
      case CustomMenuItemType.beneficts:
        return CustomMenuItem(
            title: 'Beneficios',
            color: Color.fromRGBO(30, 142, 94, 1),
            page: BenefictsPage(user: user),
            icon: AssetImage('assets/images/iconBeneficts.png'));
      // case MenuItemType.virtualCredential:
      //   return MenuItem(
      //       title: 'Credencial Digital',
      //       color: Color.fromRGBO(89, 128, 89, 1),
      //       page: VirtualCredentialPage(user: user),
      //       icon: AssetImage('assets/images/iconCredencial.png'));
      case CustomMenuItemType.contact:
        return CustomMenuItem(
            title: 'Contacto',
            color: Color.fromRGBO(142, 145, 102, 1),
            page: ContactPage(user: user),
            icon: AssetImage('assets/images/iconContacto.png'));
      case CustomMenuItemType.delete:
        return CustomMenuItem(
            title: 'Cuenta',
            color: Color.fromRGBO(220, 112, 112, 1),
            page: DeletePage(user: user),
            icon: AssetImage('assets/images/iconCredential.png'));
      case CustomMenuItemType.nosotros:
        return CustomMenuItem(
            title: 'Nosotros',
            color: Color.fromRGBO(29, 96, 143, 1),
            page: NosotrosPage(user: user),
            icon: AssetImage('assets/images/iconNosotros.png'));
      case CustomMenuItemType.prestamo:
        return CustomMenuItem(
            title: 'Resoluciones',
            color: Color.fromRGBO(129, 147, 90, 1),
            page: LoanPage(user: user),
            icon: AssetImage('assets/images/iconPrestamos.png'));
      default:
        return null;
        break;
    }
  }
}
