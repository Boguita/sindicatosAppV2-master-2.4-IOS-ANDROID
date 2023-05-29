import './NucloggerBank.dart';
import './NucloggerDispatcher.dart';
import './NucloggerLabel.dart';
import 'DataHandling/NucloggerConstants.dart';
import 'NucloggerLabelFactory.dart';
import 'NucloggerPriority.dart';

class Nuclogger {
  bool autoDispatch = false;
  NucloggerBank nucloggerBank;
  NucloggerDispatcher nucloggerDispatcher;

  Nuclogger() {
    this.nucloggerBank = NucloggerBank(
      storedLabels: []
    );
    this.nucloggerDispatcher = NucloggerDispatcher();

    this.storeLabel(
      label: NucloggerLabelFactory.systemLabel(
          content: NucloggerConstants.welcomeMessage, 
          priority: NucloggerPriority.withBasicPriority()
        )
    );
    if(!this.autoDispatch) {
      _dispatch();
    }
  }

  void _dispatch() {
    this.nucloggerDispatcher.dispatchFromBank(
      bank: this.nucloggerBank
    );
    this.nucloggerBank.clean();
  }

  void setAutoDispatch(
    {bool state}
  ) {
    this.autoDispatch = state;
  }

  void fastStoreLabel({
    String message, 
    String key
  }) {
    this.storeLabel(
      label: NucloggerLabelFactory.dataTestLabel(
          content: message, 
          priority: NucloggerPriority.withBasicPriority()
        )
    );
    this.nucloggerDispatcher.dispatchLastFromBank(
      bank: this.nucloggerBank
    );
  }

  void storeLabel({
    NucloggerLabel label
  }) {
    this.nucloggerBank.addLabel(
      label: label
    );
    if(this.autoDispatch) {
      _dispatch();
    }
  }

}