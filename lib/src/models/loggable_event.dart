import 'log_type.dart';

abstract class LoggableEvent {
  String get eventName;
  Map<String, dynamic>? get parameters;
  LogType get type;
}
