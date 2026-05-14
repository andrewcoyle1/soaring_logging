import '../log_service.dart';
import '../../models/log_type.dart';
import '../../models/loggable_event.dart';
import 'log_system.dart';

class ConsoleService implements LogService {
  final bool printParameters;
  final LogSystem _logger;

  ConsoleService({
    this.printParameters = true,
    LogSystemType system = LogSystemType.stdout,
  }) : _logger = system.createSystem();

  @override
  void trackEvent(LoggableEvent event) {
    var value = '${event.type.emoji} ${event.eventName}';
    if (printParameters) {
      final params = event.parameters;
      if (params != null && params.isNotEmpty) {
        final sortedKeys = params.keys.toList()..sort();
        for (final key in sortedKeys) {
          value += '\n    (key: "$key", value: ${params[key]})';
        }
      }
    }
    _logger.log(level: event.type, message: value);
  }

  @override
  void trackScreenView(LoggableEvent event) {
    trackEvent(event);
  }

  @override
  void identifyUser({required String userId, String? name, String? email}) {
    var string = '📈 Identify User\n    - userId: $userId';
    if (printParameters) {
      string += '\n    - name: ${name ?? 'null'}';
      string += '\n    - email: ${email ?? 'null'}';
    }
    _logger.log(level: LogType.info, message: string);
  }

  @override
  void addUserProperties({
    required Map<String, dynamic> dict,
    bool isHighPriority = false,
  }) {
    var string = '📈 Add User Properties: (isHighPriority: $isHighPriority)';
    if (printParameters) {
      final sortedKeys = dict.keys.toList()..sort();
      for (final key in sortedKeys) {
        string += '\n    (key: "$key", value: ${dict[key]})';
      }
    }
    _logger.log(level: LogType.info, message: string);
  }

  @override
  void deleteUserProfile() {
    _logger.log(level: LogType.info, message: '📈 Delete User Profile');
  }

  @override
  void log({
    required String message,
    LogType type = LogType.info,
    Object? error,
    StackTrace? stackTrace,
  }) {
    var output = '${type.emoji} $message';
    if (error != null) output += '\n    error: $error';
    if (stackTrace != null) output += '\n    $stackTrace';
    _logger.log(level: type, message: output);
  }
}
