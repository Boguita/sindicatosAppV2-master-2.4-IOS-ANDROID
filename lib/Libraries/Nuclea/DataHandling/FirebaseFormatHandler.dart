class FirebaseFormatHandler {
  dynamic getFormattedValue({
    dynamic content
  }) {
    switch(content.runtimeType) {
        case String:
          return {
            '\"stringValue\"': '\"${content.toString()}\"'
          };
          break;
        case int:
          return {
            '\"intValue\"': int.parse(content.toString())
          };
          break;
        case double:
          return {
            '\"doubleValue\"': double.parse(content.toString())
          };
          break;
        default:
          try{
            List<dynamic> defaultValue = content;
            if(defaultValue != null) {
              if(defaultValue.first.runtimeType == String) {
                List<String> tempDefVal = [];
                tempDefVal.addAll(content);
                defaultValue = tempDefVal;
              }

              List<Map<String, dynamic>> newList = [];
              for(int i=0;i<defaultValue.length;i++) {
                newList.add(getFormattedValue(
                  content: defaultValue[i]
                ));
              }

              return {
                '\"arrayValue\"': {
                  '\"values\"': newList
                }
                // '\"images\"': []
              };
            }
          }catch(e) {
            Map<String, dynamic> newFieldsList = new Map<String, dynamic>();

            Map<String, dynamic> mapFromContent = content;

            for(int i=0;i<mapFromContent.keys.length;i++) {
              String key = mapFromContent.keys.elementAt(i);
              newFieldsList['\"${key}\"'] = getFormattedValue(
                content: mapFromContent[key]
              );
            }

            return {
              '\"mapValue\"': {
                '\"fields\"': newFieldsList
              }
            };
          }
          break;
      }
  }
}