import 'models/any_loggable_event.dart';
import 'models/log_type.dart';
import 'models/loggable_event.dart';
import 'services/log_service.dart';

class LogManager {
  final List<LogService> _services;

  const LogManager({List<LogService> services = const []})
      : _services = services;

  void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
    LogType type = LogType.analytic,
  }) {
    final event = AnyLoggableEvent(
      eventName: eventName,
      parameters: parameters,
      type: type,
    );
    for (final service in _services) {
      service.trackEvent(event);
    }
  }

  void trackLoggableEvent(LoggableEvent event) {
    for (final service in _services) {
      service.trackEvent(event);
    }
  }

  void trackScreenView(LoggableEvent event) {
    for (final service in _services) {
      service.trackScreenView(event);
    }
  }

  void identifyUser({
    required String userId,
    String? name,
    String? email,
  }) {
    for (final service in _services) {
      service.identifyUser(userId: userId, name: name, email: email);
    }
  }

  void addUserProperties({
    required Map<String, dynamic> dict,
    bool isHighPriority = false,
  }) {
    for (final service in _services) {
      service.addUserProperties(dict: dict, isHighPriority: isHighPriority);
    }
  }

  void deleteUserProfile() {
    for (final service in _services) {
      service.deleteUserProfile();
    }
  }
}
