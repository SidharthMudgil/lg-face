import 'package:flutter/material.dart';

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
  ["assets/img_mouth_left.png", "Move North"],
  ["assets/img_mouth_roll_upper.png", "Move South"],
  ["assets/img_eye_blink_right.png", "Move East"],
  ["assets/img_eye_blink_left.png", "Move West"],
  ["assets/img_brow_inner_up.png", "Zoom In"],
  ["assets/img_mouth_open.png", "Zoom Out"],
];

const lgLogo = "assets/lg_logo.png";
const appLogo = "assets/icon.png";
const sidharthGithub = "LiquidGalaxyLAB";
const lgGithub = "SidharthMudgil";
const appName = "LG Face";
const appDescription = "LG-Face is a simplified Flutter-based app designed to enhance your Liquid Galaxy experience through facial gesture control. With seamless integration with the Mediapipe API, users can control their Liquid Galaxy rig remotely using various facial expressions.";

const IconData twitter = IconData(0xf099, fontFamily: "icons", fontPackage: null);
const IconData github = IconData(0xf09b, fontFamily: "icons", fontPackage: null);
const IconData linkedin_in = IconData(0xf0e1, fontFamily: "icons", fontPackage: null);
const IconData instagram = IconData(0xf16d, fontFamily: "icons", fontPackage: null);
const IconData google_play = IconData(0xf3ab, fontFamily: "icons", fontPackage: null);
