import 'DataHandling/NucloggerConstants.dart';
import 'NucloggerLabel.dart';
import 'NucloggerPriority.dart';

class NucloggerLabelFactory {

  static NucloggerLabel systemLabel({
    String content, 
    NucloggerPriority priority
  }) {
    return NucloggerLabel(
      key: NucloggerConstants.systemKey,
      message: content,
      priority: priority,
      showDateTime: true
    );
  }

  static NucloggerLabel notificationLabel({
    String content, 
    NucloggerPriority priority
  }) {
    return NucloggerLabel(
      key: NucloggerConstants.notifKey,
      message: content,
      priority: priority,
      showDateTime: true
    );
  }

  static NucloggerLabel dataTestLabel({
    String content, 
    NucloggerPriority priority
  }) {
    return NucloggerLabel(
      key: NucloggerConstants.dataTestKey,
      message: content,
      priority: priority,
      showDateTime: true
    );
  }

  static NucloggerLabel errorLabel({
    String content, 
    NucloggerPriority priority
  }) {
    return NucloggerLabel(
      key: NucloggerConstants.errorKey,
      message: content,
      priority: priority,
      showDateTime: true
    );
  }

}