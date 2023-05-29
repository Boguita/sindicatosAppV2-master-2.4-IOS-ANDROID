import 'package:flutter/material.dart';
import 'package:sindicatos/Components/LoadingComponent.dart';
import 'package:sindicatos/Model/Helper/DataSaver.dart';
import 'package:sindicatos/config.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Components/LoadingComponent.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/User.dart';
import 'package:http/http.dart' as http;
import '../../Model/Helper/DataSaver.dart';
import '../SplashPage/SplashPage.dart';

class DeletePage extends StatefulWidget {
  DeletePage({Key key, this.user}) : super(key: key);
  final User user;

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  Config config = Config();
  String dataQR = '';
  String affiliatedNumber = '';
  String id = '';
  String urlImg = '';

  @override
  void initState() {
    super.initState();

    dataQR =
        'Nombre Completo: ${widget.user.name} ${widget.user.lastName}\nDNI: ${widget.user.dni}\nNumero Afiliacion: ${widget.user.dni}';
    affiliatedNumber = '${widget.user.dni}';

    _loadId();
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

  void _loadId() async {
    DataSaver dS = DataSaver();
    await dS.getUser().then((userSaved) {
      setState(() {
        id = userSaved.id;
      });
      print(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 75),
        child: CustomAppBar(),
      ),
      backgroundColor: Colors.white,
      drawer: AppDrawer(
        user: widget.user,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo3.png'),
            fit: BoxFit.cover,
            
          ),
        ),
        child: dataQR == ''
            ? LoadingComponent()
            : ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  StickyHeader(
                    header: Container(
                      decoration: BoxDecoration(
                        // color: Colors.red,
                     
                        gradient: LinearGradient(
                                                        begin: Alignment.bottomCenter,
                                                        end: Alignment.topCenter,
                                                     colors: [Color.fromARGB(255, 24, 123, 198), Color.fromARGB(255, 9, 74, 238),]),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          PageHeader(
                            menuItem: CustomMenuItem.get(
                              CustomMenuItemType.delete,
                              widget.user,
                            ),
                            key: null,
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                    content: Container(
                      padding: EdgeInsets.only(top:0, left: 0, right: 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.85,                       

                                  child: Column(
                                  children: [
                                  
                                  Expanded(
                                  child: Column(
                                  children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                                        0.25,
                                        child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Container(decoration: BoxDecoration(
                                                       
                                                            gradient: LinearGradient(
                                                        begin: Alignment.bottomCenter,
                                                        end: Alignment.topCenter,
                                                        colors: [ Color.fromARGB(149, 214, 222, 224), Color.fromARGB(217, 242, 243, 243),]),
                                                    borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(80),
                                                      bottomRight: Radius.circular(80),
                                                    ),
                                                    
                                                        
                                                      ),
                                                    margin: const EdgeInsets.only(bottom: 60),
                                               
                                              ),
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: SizedBox(
                                                  width: 150,
                                                  height: 150,
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      Container(
                                                        decoration: const BoxDecoration(
                                                          color: Colors.black,
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png')),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                          child: Container(
                                                            margin: const EdgeInsets.all(8.0),
                                                            decoration: const BoxDecoration(
                                                                color: Colors.green, shape: BoxShape.circle),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                
                                              )
                                              
                                            ],
                                            
                                          ),
                                          

                                        
                                              ),
                                               SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                               Text(
                                                        widget.user.name.toUpperCase() + ' ' + widget.user.lastName.toUpperCase(),
                                                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                                                        ),
                                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),      
                                                        Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                        // FloatingActionButton.extended(
                                                        // onPressed: () {},
                                                        // heroTag: 'follow',
                                                        // elevation: 0,
                                                        // label: Text("Follow"),
                                                        // icon: Icon(Icons.person_add_alt_1),
                                                        // ),
                                                        // SizedBox(width: 16.0),
                                                        FloatingActionButton.extended(
                                                        onPressed: _deleteUser,
                                                        heroTag: 'delete',
                                                        elevation: 0,
                                                        backgroundColor: Colors.red,
                                                        label: Text("Elminar usuario"),
                                                        icon: Icon(Icons.delete_forever_rounded),
                                                        ),
                                                        ],
                                                        
                                                        ),
                                                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),  
                                                        ProfileInfoRow(dni: widget.user.dni, email: widget.user.email, phone: widget.user.phone,),
                                                           

                                                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),  
                                                            Container(
                                                              height: MediaQuery.of(context).size.height / 6,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: AssetImage('assets/images/logo_sindicato.png'),
                                                                  fit: BoxFit.contain,
                                                                ),
                                                              ),
                                                            ),
                                                        
                                                        

                                            ],
                                  
                                            ),   
                                  
                                  ),
                                                       
                                                        
                                                        
                                                        ],
                                                        ),
                                                        ),
                                                          ),
                                                        ),
                                                          
                                                        ],
                                                  
                                                  ),
                                                        ),
                                                        );
                                                        
                                                        
               
                                          }

void _deleteUser() async {
Map<String, String> headers = {'Content-Type': 'application/json'};
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: Text('Eliminar Usuario'),
content: Text('¿Está seguro que desea eliminar su cuenta?'),
actions: [
TextButton(
child: Text('Cancelar'),
onPressed: () {
Navigator.of(context).pop(); // Cerrar la alerta
},
),
TextButton(
child: Text('Eliminar'),
onPressed: () async {
await http
.delete(Uri.parse(config.url + '/users/$id'), headers: headers)
.then((response) async {
print(response.statusCode);
if (response.statusCode == 204) {
_closeSession();
}
});
     Navigator.of(context).pop(); // Cerrar la alerta después de eliminar el usuario
          },
        ),
      ],
    );
  },
);

}

void _closeSession() {
print('Close session method called.');
DataSaver dataSaver = DataSaver();
dataSaver.removeUser().then((result) {
Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SplashPage()));
});
}
}


class ProfileInfoRow extends StatefulWidget {

   final String dni;
   final String email;
   final String phone;

   ProfileInfoRow({this.dni, this.email, this.phone,});

   

  @override
  _ProfileInfoRowState createState() => _ProfileInfoRowState();
}

class _ProfileInfoRowState extends State<ProfileInfoRow> {
List<ProfileInfoItem> _items = [];

  @override
  void initState() {
    super.initState();

    _updateItems();
  }
  @override
  void didUpdateWidget(ProfileInfoRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateItems();
  }

  void _updateItems() {
    _items = [
      ProfileInfoItem(widget.dni != null ? widget.dni :'000', 'DNI'),
      ProfileInfoItem(widget.email != null ? widget.email : 'none', 'EMAIL'),
      ProfileInfoItem(widget.phone != null ? widget.phone : '+54-00', 'CEL'),
    ];
  

  }




@override
Widget build(BuildContext context) {
return Container(
height: 80,
constraints: BoxConstraints(maxWidth: 400),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: _items
.map(
(item) => Expanded(
child: Row(
children: [
if (_items.indexOf(item) != 0) const VerticalDivider(),
Expanded(child: _singleItem(context, item)),
],
),
),
)
.toList(),
),
);
}

Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Padding(
padding: const EdgeInsets.all(8.0),
child: Text(
item.value.toString(),
style: const TextStyle(
fontWeight: FontWeight.bold,
fontSize: 20,
),
),
),
Text(
item.title,
style: Theme.of(context).textTheme.caption,
)
],
);

}

class ProfileInfoItem {
final  title;
final  value;


const ProfileInfoItem(this.title, this.value);
}



 