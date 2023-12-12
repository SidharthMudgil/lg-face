import 'package:get_it/get_it.dart';
import 'package:ssh/ssh.dart';

/// Service that deals with the SSH management.
class SSHService {
  SettingsService get _settingsService => GetIt.I<SettingsService>();

  late SSHClient _client;

  SSHClient get client => _client;

  void setClient(SSHEntity ssh) {
    _client = SSHClient(
      host: ssh.host,
      port: ssh.port,
      username: ssh.username,
      passwordOrKey: ssh.passwordOrKey,
    );
  }

  void init() {
    final settings = _settingsService.getSettings();
    setClient(SSHEntity(
      username: settings.username,
      host: settings.ip,
      passwordOrKey: settings.password,
      port: settings.port,
    ));
  }

  Future<String?> execute(String command) async {
    String result = await connect();

    String? execResult;

    if (result == 'session_connected') {
      execResult = await _client.execute(command);
    }

    await disconnect();
    return execResult;
  }

  Future<String> connect() async {
    return _client.connect();
  }

  Future<SSHClient> disconnect() async {
    await _client.disconnect();
    return _client;
  }
}
