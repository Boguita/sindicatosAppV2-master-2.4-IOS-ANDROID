import '../../../Nuclogger/Nuclogger.dart';
import '../../../Nuclogger/NucloggerLabelFactory.dart';
import '../../../Nuclogger/NucloggerPriority.dart';
import './NucleaObserverStateListener.dart';
import './NucleaObserverConstants.dart';

class NucleaObserverStateProvider {
  Nuclogger nuclogger;
  List<NucleaObserverStateListener> observers;

  NucleaObserverStateProvider({
    Nuclogger nuclogger
  }) {
    this.nuclogger = nuclogger;
    observers = new List<NucleaObserverStateListener>();
    initState();
  }

  void initState() async {
    notify(
      state: NucleaObserverStateType.INITIALIZED
    );
  }

  void subscribe({
    dynamic state, 
    NucleaObserverStateListener listener
  }) {
    observers.add(listener);
    if(nuclogger != null){
      if(state.runtimeType == NucleaObserverStateType) {
        NucleaObserverStateType thisType = state;
        nuclogger.storeLabel(
          label: NucloggerLabelFactory.notificationLabel(
            content: NucleaObserverConstants.getNotificationMessageForNuclogger(
              type: thisType
            ), 
            priority: NucloggerPriority.withBasicPriority()
          )
        );
      }
    }
  }

  void notify({
    dynamic state
  }) {
    observers.forEach((NucleaObserverStateListener obj) => obj.onStateChanged(
      stateType: state
    ));
    if(nuclogger != null){
      if(state.runtimeType == NucleaObserverStateType) {
        NucleaObserverStateType thisType = state;
        nuclogger.storeLabel(
          label: NucloggerLabelFactory.notificationLabel(
            content: NucleaObserverConstants.getNotificationMessageForNuclogger(
              type: thisType
            ), 
            priority: NucloggerPriority.withBasicPriority()
          )
        );
      }
    }
  }

  void dispose(
    NucleaObserverStateListener thisObserver
  ) {
    for (var obj in observers) {
      if (obj == thisObserver) {
        observers.remove(obj);
      }
    }
  }
}