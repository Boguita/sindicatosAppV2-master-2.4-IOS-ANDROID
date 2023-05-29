import './NucloggerBank.dart';
import './NucloggerLabel.dart';
import 'DataHandling/NucloggerConstants.dart';
import 'NucloggerLabelFactory.dart';
import 'NucloggerPriority.dart';

class NucloggerDispatcher {

  void dispatchFromBank({
    NucloggerBank bank
  }) {
    for(NucloggerLabel label in bank.storedLabels) {
      print(label.getMessage());
    }
  }

  void dispatchLastFromBank({
    NucloggerBank bank
  }) {
    if(bank.storedLabels.isEmpty) {
      throw new Exception([
        NucloggerLabelFactory.errorLabel(
          content: NucloggerConstants.errLastDispatchFromEmptyBank, 
          priority: NucloggerPriority.withBasicPriority()
        ).getMessage(),
      ]);
    }else{
      NucloggerLabel lastLabel = bank.storedLabels.last;
      print(lastLabel.getMessage());
    }
  }

}