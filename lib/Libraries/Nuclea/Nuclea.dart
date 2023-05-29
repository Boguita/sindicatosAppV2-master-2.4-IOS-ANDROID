import './DataHandling/NucleaConstants.dart';
import 'DataHandling/FirebaseDataHandler.dart';
import 'Tools/NucleaObserver/NucleaObserverStateProvider.dart';
import 'Tools/NucleaPath.dart';
import '../Nuclogger/Nuclogger.dart';

enum NucleaServerType {
  Firebase,
  Default
}

class Nuclea {
  Nuclogger nuclogger;

  NucleaPath path;
  NucleaServerType serverType;

  FirebaseDataHandler firebaseDataHandler;

  NucleaObserverStateProvider stateProvider;
  
  Nuclea() {
    nuclogger = Nuclogger();
    path = new NucleaPath();
    serverType = NucleaServerType.Default;
    stateProvider = NucleaObserverStateProvider(
      nuclogger: nuclogger
    );

    //Activate auto dispatch by default
    nuclogger.setAutoDispatch(
      state: true
    );
  }

  Future<Map<String, dynamic>> get({
    String path
  }) async {
    switch(serverType) {
      case NucleaServerType.Firebase:
        if (firebaseDataHandler == null) {
          return NucleaConstants.Error_FirebaseHandlerError;
        }
        return await firebaseDataHandler.fetch(
          path: path
        )
          .then((Map<String, dynamic> map) {
            return map;
          })
          .catchError((onError) {
            return NucleaConstants.CustomError(
              message: onError.toString()
            );
          });
        break;
      default:
        return NucleaConstants.Error_NoServerType;
        break;
    }
  }

  Future<Map<String, dynamic>> delete({
    String path
  }) async {
    switch(serverType) {
      case NucleaServerType.Firebase:
        if (firebaseDataHandler == null) {
          return NucleaConstants.Error_FirebaseHandlerError;
        }

        return await firebaseDataHandler.delete(
          path: path
        )
          .then((Map<String, dynamic> map) {
            return map;
          })
          .catchError((onError) {
            return NucleaConstants.CustomError(
              message: onError.toString()
            );
          });
        break;
      default:
        return NucleaConstants.Error_NoServerType;
        break;
    }
  }

  String _getRequestPath(String path, Map<String, dynamic> body) {
    String requestPath = path;
    for(int i=0;i<body.keys.length;i++) {
      String extra = '';
      extra = extra + ((i == 0 ? '?' : '&'));
      String fieldName = body.keys.elementAt(i);
      requestPath = requestPath+extra+'updateMask.fieldPaths='+fieldName;
    }

    return requestPath;
  }

  Future<Map<String, dynamic>> update({
    String path, 
    Map<String, dynamic> body
  }) async {
    switch(serverType) {
      case NucleaServerType.Firebase:
        if (firebaseDataHandler == null) {
          return NucleaConstants.Error_FirebaseHandlerError;
        }

        String requestPath = _getRequestPath(path, body);

        return await firebaseDataHandler.update(
          path: requestPath, 
          body: body
        )
          .then((Map<String, dynamic> map) {
            return map;
          })
          .catchError((onError) {
            return NucleaConstants.CustomError(
              message: onError.toString()
            );
          });
        break;
      default:
        return NucleaConstants.Error_NoServerType;
        break;
    }
  }

  Future<Map<String, dynamic>> post({
    String path, 
    Map<String, dynamic> body
  }) async {
    switch(serverType) {
      case NucleaServerType.Firebase:
        if (firebaseDataHandler == null) {
          return NucleaConstants.Error_FirebaseHandlerError;
        }

        return await firebaseDataHandler.post(
          path: path, 
          body: body
        )
          .then((Map<String, dynamic> map) {
            return map;
          })
          .catchError((onError) {
            return NucleaConstants.CustomError(
              message: onError.toString()
            );
          });
        break;
      default:
        return NucleaConstants.Error_NoServerType;
        break;
    }
  }

  void activateServerTypeFirebase({
    String projectId
  }) {
    this.serverType = NucleaServerType.Firebase;
    firebaseDataHandler = FirebaseDataHandler(
      projectId: projectId
    );
  }

  void configureNucleaPath({
    List<Map<String, String>> paths
  }) {
    for (Map<String, String> path in paths) {
      this.path.addPath(
        key: path.keys.first, 
        value: path.values.first
      );
    }
  }
}