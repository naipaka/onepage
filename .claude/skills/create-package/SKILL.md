---
name: create-package
description: Create a new package in the One Page monorepo with the required LICENSE symlink, README, and workspace registration. Use when adding a new core, feature, or tools package.
argument-hint: "<core|features|tools> <package_name>"
---

# Create Package

Parse `$ARGUMENTS` as `<directory> <package_name>` where `<directory>` is `core`, `features`, or `tools`.

Follow every step below in order. Do not skip steps or use alternative methods.

---

## Step 1 — Scaffold the package

Use the official Flutter command. Manual directory creation is strictly forbidden.

```bash
fvm flutter create -t package packages/<directory>/<package_name> --project-name <package_name>
```

Example:

```bash
fvm flutter create -t package packages/core/my_utils --project-name my_utils
fvm flutter create -t package packages/features/my_feature --project-name my_feature
```

For a package with native code, create a plugin instead:

```bash
fvm flutter create -t plugin --platforms=android --org com.naipaka -a kotlin packages/<directory>/<package_name> --project-name <package_name>
```

A `tools` package is a development tool that does not use Flutter, so create it with the Dart command. Create `packages/tools` first if it does not exist, because `dart create` does not create parent directories:

```bash
fvm dart create -t package --no-pub packages/tools/<package_name>
```

For a plugin, follow the steps below, and also:

- Keep `example/`, because plugin Kotlin tests run from `example/android`. Set `resolution: workspace` in its `pubspec.yaml`.
- Add `packages/<directory>/<package_name>/example` to the root `workspace:` section.
- Put Kotlin tests in `android/src/test/kotlin`.

---

## Step 2 — Replace the LICENSE with a symbolic link

The generated LICENSE file must be replaced with a symlink to the root LICENSE file to keep the project consistent.

```bash
rm -f packages/<directory>/<package_name>/LICENSE
ln -s ../../../LICENSE packages/<directory>/<package_name>/LICENSE
```

---

## Step 3 — Replace the generated README.md

Overwrite the flutter-create template README with actual content following this structure:

````markdown
# <package_name>

A concise description of what this package does.

## Features

- Key feature 1
- Key feature 2
- Key feature 3

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  <package_name>:
    path: ../../../packages/<directory>/<package_name>
```
````

## Usage

```dart
// Practical example showing the primary use case
```

````

Do NOT leave any flutter-create template text (e.g., "A starting point for a Dart package.") in the README.

---

## Step 4 — Update the root README.md

Add a new entry for the package in the root `/README.md`. Follow the existing format and maintain alphabetical order within the `core/`, `features/`, or `tools/` section. Use a brief, informative description.

---

## Step 5 — Register in Pub Workspaces

**Root `pubspec.yaml`** — add the package path to the `workspace:` section, keeping alphabetical order:

```yaml
workspace:
  - packages/core/<package_name>   # core packages
  - packages/features/<package_name>  # features packages
  - packages/tools/<package_name>  # tools packages
````

**Package `pubspec.yaml`** (`packages/<directory>/<package_name>/pubspec.yaml`) — add the workspace resolution field:

```yaml
resolution: workspace
```

---

## Step 6 — Set standard dev_dependencies

In `packages/<directory>/<package_name>/pubspec.yaml`, replace the generated `dev_dependencies` block with the one of an existing package, at the same versions: `packages/features/haptics/pubspec.yaml` for a Flutter package, or `packages/tools/one_page_lints/pubspec.yaml` for a tools package. Every package has `altive_lints` in its dev dependencies.

Also replace the generated `analysis_options.yaml` with one that includes the root options, as `packages/features/haptics/analysis_options.yaml` does:

```yaml
analyzer:
  exclude:
    - build/**
include: ../../../analysis_options.yaml
```

---

## Step 7 — Verify the new package

```bash
fvm dart run melos bootstrap
fvm dart analyze
```

Both commands must complete without errors before the task is considered complete.
