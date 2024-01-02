import 'package:firebase_core/firebase_core.dart';

import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;
import 'flavor.dart';

FirebaseOptions firebaseOptionsWithFlavor(Flavor flavor) {
  return switch (flavor) {
    Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
    Flavor.prod => prod.DefaultFirebaseOptions.currentPlatform,
  };
}
