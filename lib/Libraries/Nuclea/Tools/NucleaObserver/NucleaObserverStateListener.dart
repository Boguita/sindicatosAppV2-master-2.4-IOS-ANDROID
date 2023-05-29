enum NucleaObserverStateType {
  INITIALIZED,
  DATA_UPDATED,
  SUBSCRIBED
}

abstract class NucleaObserverStateListener {
  void onStateChanged({NucleaObserverStateType stateType});
}