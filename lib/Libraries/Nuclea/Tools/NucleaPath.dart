class NucleaPath {
  List<Map<String, String>> pathList = [];

  void addPath({
    String key, 
    String value
  }) {
    pathList.add(
      {
        key: value
      }
    );
  }

  String getPathUsingKey({
    String key
  }) {
    var found = false;
    for (Map<String, String> path in pathList) {
      if (path.keys.contains(key)) {
        found = true;
        return path[key];
      }
    }
    if(!found) {
      return "";
    }
    return '';
  }
  
}