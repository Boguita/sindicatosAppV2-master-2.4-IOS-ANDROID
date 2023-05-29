class NucloggerConstants {
  
  static String notifKey = 'NLNTF';
  static String systemKey = 'NLSYS';
  static String dataTestKey = 'NLTEST';
  static String errorKey = 'NLERRR';

  static String welcomeMessage = 'Thanks for using Nuclogger.';

  static String errLastDispatchFromEmptyBank = 'Tried to dispatch last label from bank but NucloggerBank is empty.';

  static String getCurrentTime() {
    DateTime now = new DateTime.now();
    return 'Nuclogger - ${_convertToDoubleDigit(value:now.day)}/${_convertToDoubleDigit(value:now.month)}/${now.year} ${_convertToDoubleDigit(value:now.hour)}:${_convertToDoubleDigit(value:now.minute)}:${_convertToDoubleDigit(value:now.second)}:${now.millisecond}';
  }

  static String _convertToDoubleDigit({
    int value
  }) {
    return value.toStringAsFixed(0).padLeft(2, '0');
  }
}