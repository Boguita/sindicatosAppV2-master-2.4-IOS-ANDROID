import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sindicatos/Components/AppDrawer.dart';
import 'package:sindicatos/Components/CustomAppBar.dart';
import 'package:sindicatos/Components/FullScreenPdf.dart';
import 'package:sindicatos/Components/LoadingComponent.dart';
import 'package:sindicatos/Components/PageHeader.dart';
import 'package:sindicatos/Model/Loan.dart';
import 'package:sindicatos/Model/CustomMenuItem.dart';
import 'package:sindicatos/Model/User.dart';
import 'package:sindicatos/Network/LoanCalls.dart';
import 'package:sticky_headers/sticky_headers.dart';

class LoanPage extends StatefulWidget {
  LoanPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  TextEditingController searchController = TextEditingController();
  final Future<List<Loan>> fetchLoanFuture = getPrestamos();
  final Future<List<String>> fetchAnoFuture = getAnos();
  List<Loan> listLoans;
  List<String> listLoansSelect = [];
  String dropdownValue;
  String todos = "Todos los Años";
  int visibleLoanCount = 10;

  void initState() {
    super.initState();

    fetchLoanFuture.then((loanList) {
      setState(() {
        this.listLoans = loanList;
        _sortLoans();
      });
    });

    // Listener del dropdown
    fetchAnoFuture.then((anos) {
      setState(() {
        this.listLoansSelect.add(todos);
        this.listLoansSelect.addAll(anos);
        this.dropdownValue = listLoansSelect.first;
      });
    });
  }

  _getLoansList() {
    List<Widget> contentCells = [];
    contentCells.add(SizedBox(height: 10.0));
    contentCells.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.90,
            height: 40,
            // color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      elevation: 12,
                      style: const TextStyle(color: Color(0XFF81935a)),
                      // disabledHint: Text("Seleccione un año"),
                      onChanged: (newValue) {
                        for (String cont in this.listLoansSelect) {
                          if (cont == newValue) {
                            setState(() {
                              this.dropdownValue = cont;
                              // _changePosition();
                            });
                          }
                        }
                      },
                      items: listLoansSelect
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    )),
              ),
            ),
          ),
        ),
      ],
    ));
    contentCells.add(SizedBox(height: 10.0));
    contentCells.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.90,
                height: 40,
                // color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      style: new TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText:
                            'Ingrese palabras, frases o numeros de resolución',
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
    contentCells.add(SizedBox(height: 10.0));
    contentCells.add(
      Container(
        margin: EdgeInsets.only(right: 7.0),
        height: 40.0,
        width: 150,
        child: MaterialButton(
          height: 30.0,
          color: Color(0XFF81935a),
          textColor: Colors.white,
          onPressed: () async {
           if (searchController.text.isEmpty && dropdownValue == todos) {
              // Realizar la acción para devolver la lista completa de préstamos de todos los años
             
              fetchLoanFuture.then((loanList) {
                setState(() {
                  this.listLoans = loanList;
                  visibleLoanCount = 10;
                });
                 
              });
            } else {
             
              // Realizar la búsqueda en función del valor seleccionado del dropdown y el texto de búsqueda
              final Future<List<Loan>> fetchLoanResol =
                  getResoluciones(dropdownValue, searchController.text);
              fetchLoanResol.then((loanList) {
                setState(() {
                   print("entro 2");
                  this.listLoans = loanList;
                  visibleLoanCount = 10;
                  
                });
              });
            }
          },
          child: Text(
            'Buscar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    );

    if (listLoans.length > 0) {
      int endIndex = visibleLoanCount <= listLoans.length
          ? visibleLoanCount
          : listLoans.length;

      for (var i = 0; i < endIndex; i++) {
        contentCells.add(Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          decoration: new BoxDecoration(
              color: Color(0XFF81935a),
              borderRadius: new BorderRadius.all(
                const Radius.circular(30.0),
              )),
          height: 260.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Resolucion N° " + listLoans[i].numero,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 253, 253, 253)),
              ),
              Text(
                listLoans[i].title.toUpperCase(),
                maxLines: 4,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
              Container(
                height: 80.0,
                child: SingleChildScrollView(
                  child: Html(
                      data:
                          '<div style=\"color: #FFFFFF; font-size:14; font-weight: 700\">' +
                              listLoans[i].descripcion +
                              '</div>'),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                    height: 40.0,
                    color: Colors.white,
                    textColor: Colors.white,
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext contet) => FullScreenPdf(
                            imageUrl: listLoans[i].pdf,
                          ),
                        ),
                      );
                    },
                    child: Text('Ver [+]',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Color(0XFF3a5b40))),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0))),
              )
            ],
          ),
        ));
      }

      if (visibleLoanCount < listLoans.length) {
        contentCells.add(
       Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0XFF3a5b40)),
              ),
              onPressed: () {
                setState(() {
                  visibleLoanCount += 10;
                });
              },
              child: Text('Cargar más'),
            ),
          ),

        );
      }
    } else {
      contentCells.add(Text('No se han encontrado resultados.'));
      contentCells.add(SizedBox(height: 10.0));
    }

    var cellsToShow = contentCells;

    List<Widget> initialCell = [];

    initialCell.add(
      Container(
        color: Colors.white,
        child: Container(
          decoration: new BoxDecoration(
              color: Color(0XFF819457),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0),
              )),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              PageHeader(
                menuItem: CustomMenuItem.get(
                    CustomMenuItemType.prestamo, widget.user),
              ),
              SizedBox(height: 10.0)
            ],
          ),
        ),
      ),
    );
    initialCell.add(
      Container(
        color: Color(0XFF9ca87d),
        child: Row(
          children: <Widget>[
            SizedBox(width: 20.0),
            Expanded(
              child: Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                  child: Text("Resoluciones",
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
      ),
    );

    return ListView(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        StickyHeader(
          header: Column(children: initialCell),
          content: Column(children: cellsToShow),
        ),
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
      backgroundColor: Color(0xFFF6F6F6),
      drawer: new AppDrawer(
        user: widget.user,
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: listLoans == null ? LoadingComponent() : _getLoansList(),
            ),
          ],
        ),
      ),
    );
  }

  _sortLoans() {
    Set<String> years = {for (final loan in listLoans) loan.ano};
    List<String> sortedYears = years.toList()..sort((a, b) => b.compareTo(a));

    listLoans.sort((loan1, loan2) {
      // Ordenar por año en forma descendente
      int yearComparison = loan2.ano.compareTo(loan1.ano);
      if (yearComparison != 0) {
        return yearComparison;
      }
      // Ordenar por número de resolución en forma descendente
      return loan2.numero.compareTo(loan1.numero);
    });
  }
}
