# soaring_logging

A reusable logger for Flutter/Dart applications. `LogManager` coordinates multiple `LogService` implementations (Console, Firebase, Mixpanel, etc.) through a single API.

## Setup

<details>
<summary> Details (Click to expand) </summary>
<br>

Add `soaring_logging` to your `pubspec.yaml`:

```yaml
dependencies:
  soaring_logging:
    git:
      url: https://github.com/andrewcoyle1/soaring_logging.git
```

Import the package:

```dart
import 'package:soaring_logging/swiftful_logging.dart';
```

Create an instance of `LogManager` with one or more services:

```dart
// Development — console only
final logger = LogManager(services: [ConsoleService()]);

// Production — multiple services
final logger = LogManager(services: [
  ConsoleService(),
  FirebaseAnalyticsService(),
  FirebaseCrashlyticsService(),
  MixpanelService(token: 'your_token'),
]);
```

Optionally expose it via a provider for widget access:

```dart
Provider<LogManager>(
  create: (_) => LogManager(services: [ConsoleService()]),
  child: MyApp(),
)
```

</details>

## Services

<details>
<summary> Details (Click to expand) </summary>
<br>

`LogManager` is initialized with a list of `LogService`. `ConsoleService` is included in the package. Other services are separate packages so you can pick and choose:

- **Console** — included, prints to console via `dart:developer` or stdout

### ConsoleService

```dart
// Default — prints parameters, uses stdout
final console = ConsoleService();

// Custom — hide parameters, use dart:developer
final console = ConsoleService(printParameters: false, system: LogSystemType.developerLog);
```

### Custom LogService

Create your own by extending the abstract class:

```dart
abstract class LogService {
  void identifyUser({required String userId, String? name, String? email});
  void addUserProperties({required Map<String, dynamic> dict, bool isHighPriority = false});
  void deleteUserProfile();
  void trackEvent(LoggableEvent event);
  void trackScreenView(LoggableEvent event);
}
```

</details>

## Track Events

<details>
<summary> Details (Click to expand) </summary>
<br>

Log events with a name, optional parameters, and a log type:

```dart
logger.trackEvent(eventName: 'ButtonTapped');
logger.trackEvent(eventName: 'ButtonTapped', parameters: {'button_id': 'save'});
logger.trackEvent(eventName: 'ButtonTapped', parameters: {'button_id': 'save'}, type: LogType.analytic);
```

Use `AnyLoggableEvent` for convenience:

```dart
final event = AnyLoggableEvent(eventName: 'ButtonTapped', parameters: {'button_id': 'save'}, type: LogType.analytic);
logger.trackLoggableEvent(event);
```

**Recommended:** Implement `LoggableEvent` with a class for type-safe events:

```dart
class Event implements LoggableEvent {
  final String _eventName;
  final Map<String, dynamic>? _parameters;
  final LogType _type;

  const Event._({
    required String eventName,
    Map<String, dynamic>? parameters,
    required LogType type,
  })  : _eventName = eventName,
        _parameters = parameters,
        _type = type;

  factory Event.screenDidAppear({required String title}) => Event._(
        eventName: 'ScreenAppear',
        parameters: {'title': title},
        type: LogType.analytic,
      );

  factory Event.buttonTapped({required String id}) => Event._(
        eventName: 'ButtonTapped',
        parameters: {'button_id': id},
        type: LogType.analytic,
      );

  factory Event.screenError({required Object error}) => Event._(
        eventName: 'ScreenError',
        parameters: {'error_description': error.toString()},
        type: LogType.severe,
      );

  @override
  String get eventName => _eventName;

  @override
  Map<String, dynamic>? get parameters => _parameters;

  @override
  LogType get type => _type;
}
```

```dart
logger.trackLoggableEvent(Event.screenDidAppear(title: 'Home'));
```

</details>

## Log Types

<details>
<summary> Details (Click to expand) </summary>
<br>

Every event has a `LogType` that classifies its severity:

```dart
logger.trackEvent(eventName: 'UserLoaded', type: LogType.info);      // Informational, not an issue
logger.trackEvent(eventName: 'ScreenAppear', type: LogType.analytic); // Standard analytics (default)
logger.trackEvent(eventName: 'RetryFailed', type: LogType.warning);   // Non-breaking issue
logger.trackEvent(eventName: 'CrashDetected', type: LogType.severe);  // Breaks user experience
```

| Type | Purpose |
|---|---|
| `LogType.info` | Informational logging, not issues or errors |
| `LogType.analytic` | Standard analytics events (default) |
| `LogType.warning` | Issues that should not occur but don't break UX |
| `LogType.severe` | Critical errors that affect user experience |

Services can use the log type to handle events differently. For example, a Crashlytics service would only record `.severe` events as errors.

</details>

## Track Screen Views

<details>
<summary> Details (Click to expand) </summary>
<br>

Track screen views separately from events. Some analytics services (e.g. Firebase Analytics) have dedicated screen view tracking.

```dart
final event = AnyLoggableEvent(eventName: 'HomeScreen', type: LogType.analytic);
logger.trackScreenView(event);

// Or with a custom LoggableEvent implementation
logger.trackScreenView(Event.screenDidAppear(title: 'Home'));
```

</details>

## Manage User Profile

<details>
<summary> Details (Click to expand) </summary>
<br>

Identify the current user (log them in to all services):

```dart
logger.identifyUser(userId: 'abc123', name: 'Nick', email: 'hello@example.com');
```

Add user properties for analytics segmentation:

```dart
logger.addUserProperties(dict: {'is_premium': true, 'plan': 'annual'});
logger.addUserProperties(dict: {'account_type': 'pro'}, isHighPriority: true);
```

Note: `isHighPriority` matters for services with limited user property slots (e.g. Firebase Analytics only sets properties when `isHighPriority` is `true`).

Delete user profile:

```dart
logger.deleteUserProfile();
```

</details>

## Platform Support

- **Dart 3.0+**
- **Flutter 3.0+**

## License

soaring_logging is available under the MIT license.
