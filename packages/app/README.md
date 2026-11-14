# One Page

One-page-only diary app.

## Firebase

This project uses Firebase. Each individual must configure the Firebase settings files in the project. Please follow the steps below.

### Creating a Firebase Project

1. Visit the Firebase website ([https://firebase.google.com/](https://firebase.google.com/)) and create the necessary Firebase projects for each environment.

### Using FlutterFire CLI

In this project, we use the FlutterFire CLI to configure Firebase.

1. If FlutterFire CLI is not installed, install it using the following command:

   ```sh
   $ dart pub global activate flutterfire_cli
   ```

2. Execute the following commands in the command line to configure Firebase. Please create one for each environment.

   ```sh
   $ flutterfire configure --out=lib/environment/src/firebase_options_dev.dart --platforms=android,ios --ios-bundle-id=com.naipaka.onepage.dev --android-package-name=com.naipaka.onepage.dev --ios-out=ios/dev/GoogleService-Info.plist --android-out=android/app/src/dev/google-services.json --ios-target=Runner

   $ flutterfire configure --out=lib/environment/src/firebase_options_prod.dart --platforms=android,ios --ios-bundle-id=com.naipaka.onepage --android-package-name=com.naipaka.onepage --ios-out=ios/prod/GoogleService-Info.plist --android-out=android/app/src/prod/google-services.json --ios-target=Runner
   ```

3. Follow the instructions that appear to select your Firebase project and make the necessary configurations.

### Configuring Files

The app initializes Firebase with the Dart options of the flavor it is built for, and the build bundles the native files of the same flavor.
Place a `firebase.json` for each flavor in `ios/<flavor>/firebase.json`; the iOS build uses it to upload Crashlytics symbols to that flavor's project.
Please place the files as follows:

```
.
├── lib
│   └── environment
│       └── src
│           ├── firebase_options_dev.dart
│           └── firebase_options_prod.dart
├── android
│   └── app
│       └── src
│           ├── dev
│           │   └── google-services.json
│           └── prod
│               └── google-services.json
└── ios
    ├── dev
    │   ├── firebase.json
    │   ├── firebase_app_id_file.json
    │   └── GoogleService-Info.plist
    └── prod
        ├── firebase.json
        ├── firebase_app_id_file.json
        └── GoogleService-Info.plist
```
