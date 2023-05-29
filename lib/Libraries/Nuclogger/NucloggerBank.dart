import './NucloggerLabel.dart';

class NucloggerBank {
  List<NucloggerLabel> storedLabels;

  NucloggerBank({
    this.storedLabels
  });

  void addLabel({
    NucloggerLabel label
  }) {
    this.storedLabels.add(label);
  }

  void clean() {
    this.storedLabels = [];
  }

}