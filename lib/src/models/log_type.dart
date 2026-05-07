enum LogType {
  /// Use 'info' for informative tasks, such as tracking functions. These logs should not be considered issues or errors.
  info,

  /// Use 'analytic' for all analytic events.
  analytic,

  /// Use 'warning' for issues or errors that should not occur, but will not negatively affect user experience.
  warning,

  /// Use 'severe' for issues or errors that will negatively affect user experience, such as crashes or failing scenarios.
  severe;

  String get emoji {
    switch (this) {
      case LogType.info:
        return '👋';
      case LogType.analytic:
        return '📈';
      case LogType.warning:
        return '⚠️';
      case LogType.severe:
        return '🚨';
    }
  }

  String get asString {
    switch (this) {
      case LogType.info:
        return 'info';
      case LogType.analytic:
        return 'analytic';
      case LogType.warning:
        return 'warning';
      case LogType.severe:
        return 'severe';
    }
  }
}
