class NucloggerDrawer {
  String underscoreLines({
    int characterCount
  }) {
    return _getCharacterUsingCount(
      character: '_', 
      count: characterCount
    );
  }

  String dashedLines({
    int characterCount
  }) {
    return _getCharacterUsingCount(
      character: '-', 
      count: characterCount
    );
  }

  String cardinalLines({
    int characterCount
  }) {
    return _getCharacterUsingCount(
      character: '#',
      count: characterCount
    );
  }

  String starredLines({
    int characterCount
  }) {
    return _getCharacterUsingCount(
      character: '/\\',
      count: (characterCount/2).round()
    );
  }

  String _getCharacterUsingCount({
    String character, 
    int count
  }) {
    String value = '';
    for(int i=0;i<count;i++) {
      value = value+character;
    }
    return value;
  }
}