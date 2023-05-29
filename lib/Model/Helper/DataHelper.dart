class DataHelper {
  static bool linkIsValid(String link) {
    return (link.contains('youtu') 
            || link.contains('facebook')
            || link.contains('fb')
    );
  }
}