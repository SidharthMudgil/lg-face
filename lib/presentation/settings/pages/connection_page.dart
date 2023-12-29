import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lg_face/core/constant/constants.dart';
import 'package:lg_face/service/lg_service.dart';

import '../widgets/input_field.dart';

const String connect = "Connect";
const String disconnect = "Disconnect";

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController = TextEditingController();

  double _slaves = 3;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _isConnected();
  }

  void _isConnected() async {
    setState(() async {
      _connected = await LGService.isConnected();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Establish connection to the system',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            _connected ? 'Connected' : 'Disconnected',
            style: TextStyle(
              color: _connected ? Colors.green : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          InputField(
            label: "Username",
            hint: "lg",
            controller: userController,
            type: TextInputType.name,
          ),
          const SizedBox(height: 16),
          InputField(
            label: "Password",
            hint: "lg",
            controller: passController,
            type: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 16),
          InputField(
            label: "IP Address",
            hint: "192.168.0.1",
            controller: ipController,
            type: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          InputField(
            label: "Port Number",
            hint: "22",
            controller: portController,
            type: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Slider(
            value: _slaves,
            min: 3,
            max: 10,
            divisions: 10,
            label: "${_slaves.toInt()}",
            onChanged: (newValue) {
              setState(() {
                _slaves = newValue;
              });
            },
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: FilledButton(
              onPressed: _connectToLiquidGalaxy,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                (2 > 1) ? connect : disconnect,
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _isValidData() {
    return ipController.text.isNotEmpty &&
        portController.text.isNotEmpty &&
        userController.text.isNotEmpty &&
        passController.text.isNotEmpty;
  }

  Future<void> _connectToLiquidGalaxy() async {
    if (!_isValidData()) {
      showSnackBar("empty data");
      return;
    }

    final lgService = LGService(
      host: ipController.text,
      port: int.parse(portController.text),
      username: userController.text,
      password: passController.text,
      slaves: _slaves.toInt(),
    );

    if (await lgService.connect()) {
      showSnackBar("successful");
      LGService.instance?.performCommand(LGState.north);
      sleep(const Duration(seconds: 3));
      LGService.instance?.performCommand(LGState.idle);
    } else {
      showSnackBar("failed");
    }
  }

  void showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
