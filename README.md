[![LICENSE](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![Flutter app code check](https://github.com/naipaka/onepage/actions/workflows/flutter-app-code-check.yml/badge.svg)](https://github.com/naipaka/onepage/actions/workflows/flutter-app-code-check.yml)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)
[![codecov](https://codecov.io/gh/naipaka/onepage/graph/badge.svg?token=VSKGRHHHYW)](https://codecov.io/gh/naipaka/onepage)

<img src="./docs/icon.png" alt="One Page" width="200px" height="200px">

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

### [features/ads](packages/features/ads)

This package provides the advertisement feature of the application.

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
