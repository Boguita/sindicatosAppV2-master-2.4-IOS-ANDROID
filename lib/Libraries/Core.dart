
import 'package:intl/intl.dart';
import './Nuclea/Nuclea.dart';
import './Nuclida/Nuclida.dart';
import './PathConstants.dart';

class Core {
  static final Core instance = Core._internal();
  factory Core() => instance;

  Nuclea nuclea;
  Nuclida nuclida;
  Map<String, dynamic> currentData;

  String getDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String formatted = formatter.format(now);
    return formatted;
  }

  String getAge(String birthdate) {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy');
    String formatted = formatter.format(now);
    String birthdateYear = birthdate.split('/').last;
    int age = int.parse(formatted) - int.parse(birthdateYear);
    return '$age';
  }

  String formatDate(String date) {
    String day = '';
    String month = '';
    String dayN = '';
    String year = '';
    var datep = DateTime.parse(date);
    String dateparsed = DateFormat('E-d-LLL-y').format(datep);
    List<String> dat = dateparsed.split('-');
    dayN = dat[1];
    year = dat[3];
    switch (dat[0]) {
      case 'Mon':
        day = 'Lun';
        break;
      case 'Tue':
        day = 'Mar';
        break;
      case 'Wed':
        day = 'Mie';
        break;
      case 'Thu':
        day = 'Jue';
        break;
      case 'Fri':
        day = 'Vie';
        break;
      case 'Sat':
        day = 'Sáb';
        break;
      case 'Sun':
        day = 'Dom';
        break;
      default:
    }

    switch (dat[2]) {
      case 'Jan':
        month = 'Ene';
        break;
      case 'Apr':
        month = 'Abr';
        break;
      case 'Aug':
        month = 'Ago';
        break;
      case 'Dec':
        month = 'Dic';
        break;
      default:
        month = dat[2];
    }

    return ('$day. $dayN $month. $year');
    //String sections = date.split(' ').first;
    //List<String> sectionsB = sections.split('-');
    //return '${sectionsB.last}/${sectionsB[1]}/${sectionsB.first}';
  }

  List<String> debugListTasks = [
    // 'Agregar todo a Nuclea como Tools',
  ];

  Core._internal() {
    nuclea = new Nuclea();
    nuclea.activateServerTypeFirebase(projectId: 'galgosindicatos');
    nuclea.configureNucleaPath(paths: [
      {PathConstants.newsPath: 'news'},
      {PathConstants.historyPath: 'history'},
      {PathConstants.mediaPath: 'media'},
      {PathConstants.complaintPath: 'complaints'},
      {PathConstants.contactPath: 'contact'},
      {PathConstants.benefictPath: 'beneficts'},
      {PathConstants.usersPath: 'users'},
    ]);

    this.nuclida = new Nuclida();
  }
}
