import './NucloggerDrawer.dart';
import './NucloggerPriority.dart';
import './Tools/NucloggerKeys.dart';
import 'DataHandling/NucloggerConstants.dart';

class NucloggerLabel {
  final String key;
  final String message;
  final NucloggerPriority priority;
  bool showDateTime = true;

  NucloggerLabel({
    this.key,
    this.message,
    this.priority,
    this.showDateTime
  });

  String getMessage() {
    NucloggerDrawer drawer = NucloggerDrawer();
    String messageToReturn = '';

    switch(this.priority.type) {
      case NucloggerPriorityType.BASIC:
        List<String> messageLines = _getMessagesLines(
          message: '${this.key}: ${this.message}'
        );
        for(String line in messageLines) {
          messageToReturn = messageToReturn + '${line}\n';
        }
        break;
      case NucloggerPriorityType.FRAMED:
        List<String> messageLines = _getMessagesLines(
          message: '${this.key}: ${this.message}'
        );
        messageToReturn = messageToReturn + drawer.underscoreLines(
          characterCount: messageLines.first.length
        );
        for(String line in messageLines) {
          messageToReturn = messageToReturn + '${line}\n';
        }
        messageToReturn = messageToReturn + drawer.underscoreLines(
          characterCount: messageLines.first.length
        );
        break;
    }

    return messageToReturn;
  }

  List<String> _getMessagesLines({
    String message
  }) {
    List<String> newList = message.split(NucloggerKeys.newLineChar);
    if(this.showDateTime) {
      newList.insert(0, NucloggerConstants.getCurrentTime());
    }
    return newList;
  }

}