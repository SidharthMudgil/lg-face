import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lg_face/core/constant/constants.dart';
import 'package:lg_face/service/lg_service.dart';

import 'widgets/input_field.dart';
import 'widgets/input_label.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const InputLabel(
            label: "Username",
          ),
          InputField(
            hintText: "lg",
            inputController: userController,
            inputType: TextInputType.name,
          ),
          const SizedBox(
            height: 16,
          ),
          const InputLabel(
            label: "Password",
          ),
          InputField(
            hintText: "lg",
            inputController: passController,
            inputType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 16,
          ),
          const InputLabel(
            label: "IP Address",
          ),
          InputField(
            hintText: "192.168.0.1",
            inputController: ipController,
            inputType: TextInputType.phone,
          ),
          const SizedBox(
            height: 16,
          ),
          const InputLabel(
            label: "Port Number",
          ),
          InputField(
            hintText: "22",
            inputController: portController,
            inputType: TextInputType.number,
          ),
          const SizedBox(
            height: 16,
          ),
          const InputLabel(
            label: "Total Screens",
          ),
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
          const SizedBox(
            height: 16,
          ),
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
    return ipController.text != "" &&
        portController.text != "" &&
        userController.text != "" &&
        passController.text != "";
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

    debugPrint("host: ${ipController.text}");
    debugPrint("port: ${int.parse(portController.text)}");
    debugPrint("username: ${userController.text}");
    debugPrint("password: ${passController.text}");
    debugPrint("slaves: ${_slaves.toInt()}");
    
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
