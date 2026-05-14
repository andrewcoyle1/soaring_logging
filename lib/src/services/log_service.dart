import '../models/log_type.dart';
import '../models/loggable_event.dart';

abstract class LogService {
  void identifyUser({
    required String userId,
    String? name,
    String? email,
  });

  void addUserProperties({
    required Map<String, dynamic> dict,
    bool isHighPriority = false,
  });

  void deleteUserProfile();

  void trackEvent(LoggableEvent event);

  void trackScreenView(LoggableEvent event);

  void log({
    required String message,
    LogType type = LogType.info,
    Object? error,
    StackTrace? stackTrace,
  });
}
