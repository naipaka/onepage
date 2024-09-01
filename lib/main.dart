import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'environment/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flavor = Flavor.values.byName(const String.fromEnvironment('flavor'));

  await Firebase.initializeApp(options: firebaseOptionsWithFlavor(flavor));

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
