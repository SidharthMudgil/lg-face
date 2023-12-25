import 'package:flutter/material.dart';
import 'package:ssh2/ssh2.dart';

import '../core/constant/constants.dart';

class LGService {
  late SSHClient _client;
  static LGState _lastState = LGState.idle;
  static LGService? instance;

  factory LGService({
    required String host,
    required int port,
    required String username,
    required String password,
    required int slaves,
  }) {
    instance ??= LGService._internal(
      host: host,
      port: port,
      username: username,
      password: password,
      slaves: slaves,
    );
    return instance!;
  }

  LGService._internal({
    required String host,
    required int port,
    required String username,
    required String password,
    required int slaves,
  }) {
    _client = SSHClient(
        host: host, port: port, username: username, passwordOrKey: password);
  }

  SSHClient get client => _client;

  Future<bool> connect() async {
    try {
      String? result = await _client.connect();
      debugPrint("$result");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> disconnect() async {
    try {
      String? result = await _client.disconnect();
      debugPrint("$result");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _execute(String query) async {
    try {
      var result = await _client.execute(query);
      debugPrint("$result");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> performCommand(LGState state) async {
    debugPrint("state: ${state.state} lastState: ${_lastState.state}");

    String command = "";

    if ((state == LGState.idle) || (_lastState != LGState.idle && _lastState != state)) {
      command = 'export DISPLAY=:0; xdotool keyup ${_lastState.state}';
      _lastState = LGState.idle;
    } else if (state != LGState.idle) {
      command = "export DISPLAY=:0; xdotool keydown ${state.state}";
      _lastState = state;
    }

    return await _execute(command);
  }
}
