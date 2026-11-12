import 'dart:isolate';
import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:tracker/tracker.dart';

import 'app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.initializeFirebase();

  final tracker = Tracker();
  // Logs errors caught by the Flutter framework.
  FlutterError.onError = tracker.onFlutterError;
  // Logs uncaught asynchronous errors that the Flutter framework cannot catch.
  PlatformDispatcher.instance.onError = tracker.onPlatformError;
  // Logs errors outside the Flutter environment.
  Isolate.current.addErrorListener(tracker.isolateErrorListener());

  final app = await AppInitializer.createApp(tracker: tracker);
  runApp(app);
}
