import 'package:sindicatos/config.dart';

class Loan {
  final String id;
  final String title;
  final String pdf;
  final String descripcion;
  final String ano;
  final String numero;

  Loan(
      {this.id, this.title, this.pdf, this.descripcion, this.ano, this.numero});

  factory Loan.fromJson(Map<String, dynamic> json) {
    Config config = new Config();
    Map<String, dynamic> fields = json;
    Loan loan = Loan(
        id: fields['id'].toString(),
        title: fields['title'].toString(),
        pdf: config.url + "/assets/" + fields['archivo_pdf'],
        descripcion: fields['descripcion'],
        ano: fields["ano"].toString(),
        numero: fields["numero_resolucion"]);

    return loan;
  }
}
