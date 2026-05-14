import 'log_manager.dart';
import 'models/log_type.dart';

class ScopedLogger {
  final LogManager _manager;
  final String _scope;

  const ScopedLogger(this._manager, this._scope);

  void debug(String message) =>
      _manager.log(message: '[$_scope] $message', type: LogType.info);

  void warning(String message, [Object? error, StackTrace? stackTrace]) =>
      _manager.log(message: '[$_scope] $message', type: LogType.warning, error: error, stackTrace: stackTrace);

  void severe(String message, [Object? error, StackTrace? stackTrace]) =>
      _manager.log(message: '[$_scope] $message', type: LogType.severe, error: error, stackTrace: stackTrace);
}
