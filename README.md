![Pub Version](https://img.shields.io/badge/dynamic/yaml?color=blue&label=release&query=version&url=https://raw.githubusercontent.com/naipaka/onepage/main/packages/app/pubspec.yaml)
[![LICENSE](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![Flutter app code check](https://github.com/naipaka/onepage/actions/workflows/flutter-app-code-check.yml/badge.svg)](https://github.com/naipaka/onepage/actions/workflows/flutter-app-code-check.yml)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)
[![codecov](https://codecov.io/gh/naipaka/onepage/graph/badge.svg?token=VSKGRHHHYW)](https://codecov.io/gh/naipaka/onepage)

<img src="./docs/icon.png" alt="One Page" width="200px" height="200px">

[<img src="./docs/appstore-badge.png" height="50">](https://apps.apple.com/us/app/one-page-simple-diary/id6738889085)
[<img src="./docs/google-play-badge.png" height="50">](https://play.google.com/store/apps/details?id=com.naipaka.onepage)

# One Page

"One Page" is a simple diary app with no input pages or date pages, just "one page only."

![screenshot](./docs/store-en.png)

## Packages overview

This project is experimentally divided into packages by feature.

![dependency_graph](./docs/dependency_graph.svg)

### [app (onepage)](packages/app)

This package contains the entry point of the application and is the main package of the application.

### [core/db_client](packages/core/db_client)

This package provides a database client for the application.

### [core/i18n](packages/core/i18n)

This package supports the internationalization and localization of the application. All texts for translating the application's text are defined here.

### [core/provider_utils](packages/core/provider_utils)

This package provides utility functions for the riverpod package.

### [core/theme](packages/core/theme)

This package is responsible for the appearance of `ThemeData` and other appearance-related data used in Flutter apps.

### [core/utils](packages/core/utils)

This package provides utility functions for the application.

### [core/widgets](packages/core/widgets)

This package provides generic widgets for the application.

### [features/backup](packages/features/backup)

This package provides the backup feature of the application.

### [features/diary](packages/features/diary)

This package provides the diary feature of the application.

### [features/scroll_calendar](packages/features/scroll_calendar)

This package provides a scrollable calendar.

### [features/update_requester](packages/features/update_requester)

This package manages application updates.

## How to start development

```shell
make
```

The `make` command will install the required Dart packages, such as FVM and Melos.

### Firebase Integration
Run the following commands to generate Firebase configuration files:

#### For Development Environment
```shell
flutterfire configure --out=lib/environment/src/firebase_options_dev.dart --platforms=android,ios --ios-bundle-id=com.naipaka.onepage.dev --android-package-name=com.naipaka.onepage.dev
```

Move the generated `ios/Runner/GoogleService-Info.plist` to `ios/dev/` directory.

#### For Production Environment
```shell
flutterfire configure --out=lib/environment/src/firebase_options_prod.dart --platforms=android,ios --ios-bundle-id=com.naipaka.onepage --android-package-name=com.naipaka.onepage
```

Move the generated `ios/Runner/GoogleService-Info.plist` to `ios/prod/` directory.

### Environment Variables
Place the following environment variable files in the `packages/app/dart_defines` directory:
- `dev.env`: Development environment variables
- `prod.env`: Production environment variables

## How to create a new package

If the project name and the output directory name of the package are the same,
`--project-name` can be omitted.

```shell
# Package
flutter create -t package packages/{directory_name} --project-name {project_name}
# App
flutter create --org jp.co.altive packages/{directory_name} --project-name {project_name}
```

## How to run tests

To run tests for the project, use the following command:

```shell
melos run test
```

This command will execute all tests defined in the project.

## How to build the project

To build the project, use the following command:

```shell
melos run build
```

or 

```shell
melos run build:watch
```

This command will build the project for the specified platforms.
