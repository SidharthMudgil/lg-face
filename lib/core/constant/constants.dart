class LGState {
  final String state;

  const LGState._(this.state);

  static const LGState idle = LGState._("idle");
  static const LGState north = LGState._("Up");
  static const LGState south = LGState._("Down");
  static const LGState east = LGState._("Right");
  static const LGState west = LGState._("Left");
  static const LGState zoomIn = LGState._("equal");
  static const LGState zoomOut = LGState._("minus");
}