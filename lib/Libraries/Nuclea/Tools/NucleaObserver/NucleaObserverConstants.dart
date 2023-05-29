import './NucleaObserverStateListener.dart';

class NucleaObserverConstants {

  static String getNotificationMessageForNuclogger({
    NucleaObserverStateType type
  }) {
    switch(type) {
      case NucleaObserverStateType.INITIALIZED:
        return 'Initializated';
      case NucleaObserverStateType.DATA_UPDATED:
        return 'Data Updated';
      case NucleaObserverStateType.SUBSCRIBED:
        return 'Subscribed';
    }
    return '';
  }

}