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

const gestures = [
  ["assets/img_mouth_roll_upper.png", "Move North"],
  ["assets/img_mouth_roll_lower.png", "Move South"],
  ["assets/img_eye_blink_right.png", "Move East"],
  ["assets/img_eye_blink_left.png", "Move West"],
  ["assets/img_brow_inner_up.png", "Zoom In"],
  ["assets/img_mouth_open.png", "Zoom Out"],
];
