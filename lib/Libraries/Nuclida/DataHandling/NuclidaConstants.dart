enum NuclidaOrientationType {
  Horizontal,
  Vertical
}

enum NuclidaSimpleLineType {
  None,
  Thin,
  Medium,
  Bold
}

class NuclidaConstants {
  static double getValueForLine({
    NuclidaSimpleLineType lineType
  }) {
    switch(lineType) {
      case NuclidaSimpleLineType.None: return 0;
      case NuclidaSimpleLineType.Thin: return 1;
      case NuclidaSimpleLineType.Medium: return 3;
      case NuclidaSimpleLineType.Bold: return 5;
    }
    return 0;
  }
}