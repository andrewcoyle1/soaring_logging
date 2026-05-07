import 'dart:developer' as developer;
import '../../models/log_type.dart';

abstract class LogSystem {
  void log({required LogType level, required String message});
}

enum LogSystemType {
  developerLog,
  stdout;

  LogSystem createSystem() {
    switch (this) {
      case LogSystemType.developerLog:
        return DeveloperLogSystem();
      case LogSystemType.stdout:
        return StdoutLogSystem();
    }
  }
}

/// Uses dart:developer log — visible in IDE debug consoles and Flutter DevTools.
class DeveloperLogSystem implements LogSystem {
  @override
  void log({required LogType level, required String message}) {
    developer.log(message, name: 'SoaringLogging', level: _levelValue(level));
  }

  int _levelValue(LogType level) {
    switch (level) {
      case LogType.info:
        return 800;
      case LogType.analytic:
        return 800;
      case LogType.warning:
        return 900;
      case LogType.severe:
        return 1000;
    }
  }
}

/// Uses print() — visible anywhere stdout is captured.
class StdoutLogSystem implements LogSystem {
  @override
  void log({required LogType level, required String message}) {
    print(message);
  }
}
