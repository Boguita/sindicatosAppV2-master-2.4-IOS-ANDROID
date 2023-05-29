class NucleaConstants {
  static String _MSG_NO_SERVER_TYPE = 'There\'s no server type activated. Use the activateServerType method.';
  static String _MSG_FIREBASE_HANDLER_ERROR = 'The server type activated is Firebase but firebaseDataHandler is null.';

  static Map<String, dynamic> Error_NoServerType = {
    'error': NucleaConstants._MSG_NO_SERVER_TYPE
  };

  static Map<String, dynamic> Error_FirebaseHandlerError = {
    'error': NucleaConstants._MSG_FIREBASE_HANDLER_ERROR
  };

  static Map<String, dynamic> CustomError({
    String message
  }) {
    return {
      'error': message
    };
  }

}