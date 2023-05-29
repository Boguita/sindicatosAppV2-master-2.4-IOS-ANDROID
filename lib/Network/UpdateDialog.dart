import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatefulWidget {
  final String version;
  final String description;
  final String appLink;
  final bool allowDismissal;

  const UpdateDialog({
    Key key,
    this.version = " ",
    this.description,
    this.appLink,
    this.allowDismissal = false,
  }) : super(key: key);
  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  void dispose() {
    if(!widget.allowDismissal) {
      print("EXIT APP");
      // SystemNavigator.pop(); this will close the app
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: content(context),
      ),
    );
  }

Widget content(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      return !widget.allowDismissal;
    },
    child: GestureDetector(
      onTap: () {
        if (!widget.allowDismissal) {
          // No se hace nada si se toca fuera del diálogo
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: screenHeight / 8,
            width: screenWidth / 1.5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: Color.fromARGB(255, 145, 180, 255),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo_icono.png',
                width: 160,
                height: 140,
              ),
            ),
          ),
          Container(
            height: screenHeight / 3,
            width: screenWidth / 1.5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Stack(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "NUEVA ACTUALIZACIÓN",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    widget.version,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12,),
                          Expanded(
                            flex: 5,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    widget.description,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top:30),
                                    child: BounceInUp(
                                      child: Icon(
                                        Icons.error_outline_outlined,
                                        color: Color.fromARGB(255, 145, 180, 255),
                                        size: 60,
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
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // widget.allowDismissal ? Expanded(
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       Navigator.pop(context);
                          //     },
                              // child: Container(
                              //   height: 30,
                              //   width: 120,
                              //   decoration: BoxDecoration(
                              //     border: Border.all(
                              //       color: Color.fromARGB(255, 145, 180, 255),
                              //     ),
                              //     borderRadius: BorderRadius.circular(50),
                              //   ),
                              // ),
                            const SizedBox(),
                          SizedBox(width: widget.allowDismissal ? 16 : 0,),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  await launchUrl(Uri.parse(widget.appLink));
                                } catch (e) {
                                  print('Error al lanzar la URL: $e');
                                  // Maneja el error de manera adecuada, como mostrar un mensaje al usuario
                                }
                              },
                              // Resto del código
                            
                              child: Container(
                                height: 30,
                                width: 120,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(50),
color: Color.fromARGB(255, 99, 148, 255),
boxShadow: const [
BoxShadow(
color: Color.fromARGB(255, 99, 148, 255),
blurRadius: 10,
offset: Offset(2, 2),
),
],
),
child: const Center(
child: Text(
"ACTUALIZAR",
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
),
),
),
),
],
),
),
),
],
),
),
),
],
),
),
);
}         
           
       
  }



// widget.allowDismissal ? Expanded(
                          // child: GestureDetector(
                          //   onTap: () {
                              
                          //   },
                          //   // child: Container(
                          //   //   // height: 30,
                          //   //   // width: 120,
                          //   //   // decoration: BoxDecoration(
                          //   //   //   border: Border.all(
                          //   //   //     color: Color.fromARGB(
                          //   //   //                 255, 145, 180, 255)
                          //   //   //   ),
                          //   //   //   borderRadius: BorderRadius.circular(50),
                          //   //   ),
                          //     // child: const Center(
                          //     //   child: Text(
                          //     //     "MÁS TARDE",
                          //     //     style: TextStyle(
                          //     //       color: Color.fromARGB(
                          //     //                 255, 145, 180, 255),
                          //     //       fontWeight: FontWeight.bold,
                          //     //     ),
                          //     //   ),
                          //     // ),
                          //   ), 

// import 'dart:async';
// import 'package:new_version/new_version.dart';

// class NewVersionChecker {
//   void checkVersion() {
//     final newVersion = NewVersion(androidId: "com.galgo.uatre");

//     Timer(const Duration(milliseconds: 800), () {
//       checkNewVersion(newVersion);
//     });
//   }

//   void checkNewVersion(NewVersion newVersion) {
//     newVersion.getVersionStatus().then((res) {
//       print(res);
//       // if (status != null) {
//       //   print(status);
//       //   if (status.canUpdate) {
//       //     newVersion.showUpdateDialog(
//       //       context: context,
//       //       versionStatus: status,
//       //       dialogText: '(${status.storeVersion}). Por favor, actualiza a la ultima version para acceder a las funciones mas recientes.',
//       //       dialogTitle: '¡Nueva version en la tienda!'
//       //     );
//       //   }
//       // }
//     });
//   }
// }
