import 'package:flutter/material.dart';
import 'package:lg_face/core/constant/constants.dart';
import 'package:lg_face/service/lg_service.dart';

import '../widgets/lg_button.dart';

class LiquidGalaxyPage extends StatefulWidget {
  const LiquidGalaxyPage({super.key});

  @override
  State<LiquidGalaxyPage> createState() => _LiquidGalaxyPageState();
}

class _LiquidGalaxyPageState extends State<LiquidGalaxyPage> {
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _isConnected();
  }

  void _isConnected() async {
    _connected = await LGService.isConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LGButton(
            label: 'SET SLAVES REFRESH',
            icon: Icons.av_timer_rounded,
            onPressed: () {
              LGService.instance?.connect();
            },
            enabled: _connected,
          ),
          LGButton(
            label: 'RESET SLAVES REFRESH',
            icon: Icons.timer_off_rounded,
            onPressed: () {
              LGService.instance?.connect();
            },
            enabled: _connected,
          ),
          LGButton(
            label: 'Clear KML + logos',
            icon: Icons.cleaning_services_rounded,
            onPressed: () {
              LGService.instance?.connect();
            },
            enabled: _connected,
          ),
          LGButton(
            label: 'Relaunch',
            icon: Icons.reset_tv_rounded,
            onPressed: () {
              LGService.instance?.connect();
            },
            enabled: _connected,
          ),
          LGButton(
            label: 'Reboot',
            icon: Icons.restart_alt_rounded,
            onPressed: () {
              LGService.instance?.connect();
            },
            enabled: _connected,
          ),
          LGButton(
            label: 'Power off',
            icon: Icons.power_settings_new_rounded,
            onPressed: () {
              LGService.instance?.connect();
            },
            enabled: _connected,
          ),
        ],
      ),
    );
  }
}
