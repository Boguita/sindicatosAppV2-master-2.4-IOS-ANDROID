enum NucloggerPriorityType {
  BASIC,
  FRAMED
}

class NucloggerPriority {
  final NucloggerPriorityType type;

  NucloggerPriority({
    this.type
  });

  static NucloggerPriority withBasicPriority() {
    return NucloggerPriority(
      type: NucloggerPriorityType.BASIC
    );
  }

  static NucloggerPriority withFramedPriority() {
    return NucloggerPriority(
      type: NucloggerPriorityType.FRAMED
    );
  }
  
}