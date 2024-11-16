import 'package:logging/logging.dart';

// Define and configure the global logger
final Logger mainLogger = Logger('Main');

void setupLogging() {
  Logger.root.level = Level.ALL; // Capture all log levels
  Logger.root.onRecord.listen((LogRecord rec) {
    // ignore: avoid_print
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
