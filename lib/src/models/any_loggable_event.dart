import 'log_type.dart';
import 'loggable_event.dart';

class AnyLoggableEvent implements LoggableEvent {
  @override
  final String eventName;

  @override
  final LogType type;

  @override
  final Map<String, dynamic>? parameters;

  const AnyLoggableEvent({
    required this.eventName,
    this.parameters,
    this.type = LogType.analytic,
  });
}
