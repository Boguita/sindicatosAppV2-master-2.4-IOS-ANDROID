import './FirebaseFormatHandler.dart';
import 'package:random_string/random_string.dart' as random;

class FirebaseConstants {
  static String _MSG_FAILED_TO_FETCH = 'Failed to fetch from Firebase';

  static Map<String, dynamic> Error_FailedToFetch = {
    'error': FirebaseConstants._MSG_FAILED_TO_FETCH
  };

  static dynamic formatMapForFirestore({
    Map<String, dynamic> originalMap
  }) {
    FirebaseFormatHandler formatHandler = new FirebaseFormatHandler();
    Map<String, dynamic> map;

    Map<String, dynamic> fieldsMap = {};
    for(int i=0;i<originalMap.keys.length;i++) {
      String key = originalMap.keys.elementAt(i);
      dynamic content = originalMap[key];
      if(content.toString().substring(0, 1) == '[') {
        List<dynamic> listResult = [];
        List<dynamic> dynamicList = content;
        for(dynamic dynamicListItem in dynamicList) {
          if(dynamicListItem.runtimeType == String) {
            listResult.add({
              '\"stringValue\"': '\"${dynamicListItem.toString()}\"'
            });
          }else{
            listResult.add({
              '\"mapValue\"': formatMapForFirestore(
                originalMap: dynamicListItem
              )
            });
          }
        }

        fieldsMap['\"${key}\"'] = {
          '\"arrayValue\"': {
            '\"values\"': listResult
          }
        };
      }else{
        fieldsMap['\"${key}\"'] = formatHandler.getFormattedValue(
          content: content
        );
      }
    }
    
    map = {
      '\"fields\"': fieldsMap
    };
    
    return map.toString();
  }

  static Map<String, dynamic> cleanAndFormat({
    String projectId, 
    Map<String, dynamic> item
  }) {
    String myRandomKey = random.randomAlpha(10);
    Map<String, dynamic> thisMap = new Map<String, dynamic>();

    Map<String, dynamic> fields = item['fields'];
    for(var i=0;i<fields.keys.length;i++) {
      String fieldItem = fields.keys.elementAt(i);
      if(FirebaseConstants.processField(
        key: fieldItem,
        field: fields[fieldItem]
      ).runtimeType == List) {
        List<dynamic> newList = new List<dynamic>();
        List<dynamic> liist = processField(
          key: fieldItem,
          field: fields[fieldItem]
        );
        newList.addAll(liist);
        thisMap[fieldItem] = newList;
      }else{
        dynamic dynamicField = FirebaseConstants.processField(
          key: fieldItem,
          field: fields[fieldItem]
        );
        if(dynamicField.toString().substring(0, 1) == '[') {
          List<dynamic> newList = new List<dynamic>();
          List<dynamic> liist = processField(
            key: fieldItem,
            field: fields[fieldItem]
          );
          newList.addAll(liist);
          thisMap[fieldItem] = newList;
        }else{
          thisMap[fieldItem] = dynamicField[fieldItem];
        }
      }
    }

    String name = item['name'].toString();
    name = name.replaceAll(
      'projects/${projectId}/databases/(default)/documents/', 
      ''
    );

    name = name.split('/').last ?? name;

    return {
      'name': name,
      'fields': thisMap
    };
  }

  static Map<String, dynamic> SuccessRequest({
    String projectId, 
    String requestUrl, 
    Map<String, dynamic> content
  }) {
    //Checking if it's a list
    List<dynamic> documents = content['documents'];
    // Map<String, dynamic> thisDocument = 
    if(documents != null) {
      List<Map<String, dynamic>> resultMap = [];
      for(Map<String, dynamic> item in documents) {
        resultMap.add(FirebaseConstants.cleanAndFormat(
          projectId: projectId, 
          item: item
        ));
      }

      return {
        'response': resultMap
      };
    }

    Map<String, dynamic> document = content;
    if(document != null) {
      return {
        'response': FirebaseConstants.cleanAndFormat(
          projectId: projectId, 
          item: document
        )
      };
    }
    
  }

  static bool isVariableType(String value) {
    return (
      value == 'stringValue' ||
      value == 'intValue' ||
      value == 'doubleValue' ||
      value == 'arrayValue' ||
      value == 'mapValue'
    );
  }
  
  static dynamic processField({
    String key, 
    Map<String, dynamic> field
  }) {

    if(field['stringValue'] != null) {
      Map<String, String> map = {
        key: field['stringValue'].toString()
      };
      return map;
    }else if(field['arrayValue'] != null) {
      String myRandomKey = random.randomAlpha(10);
      Map<String, dynamic> arrayValue = field['arrayValue'];

      if(arrayValue.keys.isEmpty) {
        return {
          key: []
        };
      }
      
      List<dynamic> listArrayValues = arrayValue['values'];
      List<dynamic> listValues = [];

      if(listArrayValues.isNotEmpty) {
        for(dynamic item in listArrayValues) {
          if(item['mapValue'] != null) {
            Map<String, dynamic> mapValueJson = item['mapValue'];
            Map<String, dynamic> fieldsJson = mapValueJson['fields'];

            Map<String, dynamic> resultMap = new Map<String, dynamic>();
            for(int i=0;i<fieldsJson.keys.length;i++) {
              String thisKey = fieldsJson.keys.elementAt(i);
              dynamic resultDynamic = processField(
                key: thisKey,
                field: fieldsJson[thisKey]
              );
              if(resultDynamic.runtimeType == List){
                List<dynamic> newList = new List<dynamic>();
                newList.addAll(processField(
                  key: thisKey,
                  field: fieldsJson[thisKey]
                ));
                resultMap[thisKey] = newList;
              }else{
                try{
                  List<dynamic> tempItem = processField(
                    key: thisKey,
                    field: fieldsJson[thisKey]
                  );

                  List<dynamic> newList = new List<dynamic>();
                  newList.addAll(tempItem);
                  resultMap[thisKey] = newList;
                }catch(e){
                  resultMap[thisKey] = processField(
                    key: thisKey,
                    field: fieldsJson[thisKey]
                  )[thisKey];
                }
              }
            }
            listValues.add(resultMap);
          }else{
            dynamic itemProcessed = processField(
              key: 'result', 
              field: item
            )['result'];
            listValues.add(itemProcessed);
          }
        }
      }
      return listValues;
    }else if(field['integerValue'] != null) {
      return {
        key: int.parse(field['integerValue'].toString())
      };
    }else if(field['doubleValue'] != null) {
      return {
        key: double.parse(field['doubleValue'].toString())
      };
    }else{
      return {
        'missing': 'missing'
      };
    }
  }

}