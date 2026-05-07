import 'package:swiftful_logging/swiftful_logging.dart';
import 'package:test/test.dart';

void main() {
  group('LogManager', () {
    test('tracks event and forwards the call to all services', () {
      final mockService1 = MockLogService();
      final mockService2 = MockLogService();
      final logManager = LogManager(services: [mockService1, mockService2]);
      final event = AnyLoggableEvent(
        eventName: 'Test Event',
        parameters: {'key': 'value'},
        type: LogType.info,
      );

      logManager.trackLoggableEvent(event);

      expect(mockService1.lastTrackedEvent?.eventName, 'Test Event');
      expect(mockService2.lastTrackedEvent?.eventName, 'Test Event');
    });

    test('tracks screen view and forwards the call to all services', () {
      final mockService1 = MockLogService();
      final mockService2 = MockLogService();
      final logManager = LogManager(services: [mockService1, mockService2]);
      final event = AnyLoggableEvent(
        eventName: 'Screen Viewed',
        parameters: {'screen': 'Home'},
        type: LogType.analytic,
      );

      logManager.trackScreenView(event);

      expect(mockService1.lastTrackedScreenView?.eventName, 'Screen Viewed');
      expect(mockService2.lastTrackedScreenView?.eventName, 'Screen Viewed');
    });

    test('identifies user and forwards the call to all services', () {
      final mockService1 = MockLogService();
      final mockService2 = MockLogService();
      final logManager = LogManager(services: [mockService1, mockService2]);

      logManager.identifyUser(
        userId: 'user123',
        name: 'John Doe',
        email: 'john.doe@example.com',
      );

      expect(mockService1.lastIdentifiedUserId, 'user123');
      expect(mockService2.lastIdentifiedUserId, 'user123');
    });

    test('adds user properties and forwards the call to all services', () {
      final mockService1 = MockLogService();
      final mockService2 = MockLogService();
      final logManager = LogManager(services: [mockService1, mockService2]);
      final dict = {'property1': 'value1', 'property2': 'value2'};

      logManager.addUserProperties(dict: dict, isHighPriority: false);

      expect(mockService1.lastAddedUserProperties?['property1'], 'value1');
      expect(mockService2.lastAddedUserProperties?['property1'], 'value1');
    });

    test('deletes user profile and forwards the call to all services', () {
      final mockService1 = MockLogService();
      final mockService2 = MockLogService();
      final logManager = LogManager(services: [mockService1, mockService2]);

      logManager.deleteUserProfile();

      expect(mockService1.didDeleteUserProfile, isTrue);
      expect(mockService2.didDeleteUserProfile, isTrue);
    });
  });
}

class MockLogService implements LogService {
  LoggableEvent? lastTrackedEvent;
  LoggableEvent? lastTrackedScreenView;
  String? lastIdentifiedUserId;
  String? lastIdentifiedName;
  String? lastIdentifiedEmail;
  Map<String, dynamic>? lastAddedUserProperties;
  bool? lastIsHighPriority;
  bool didDeleteUserProfile = false;

  @override
  void trackEvent(LoggableEvent event) {
    lastTrackedEvent = event;
  }

  @override
  void trackScreenView(LoggableEvent event) {
    lastTrackedScreenView = event;
  }

  @override
  void identifyUser({required String userId, String? name, String? email}) {
    lastIdentifiedUserId = userId;
    lastIdentifiedName = name;
    lastIdentifiedEmail = email;
  }

  @override
  void addUserProperties({
    required Map<String, dynamic> dict,
    bool isHighPriority = false,
  }) {
    lastAddedUserProperties = dict;
    lastIsHighPriority = isHighPriority;
  }

  @override
  void deleteUserProfile() {
    didDeleteUserProfile = true;
  }
}
