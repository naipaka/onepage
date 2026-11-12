# Troubleshooting

Problems met while handling Dependabot PRs, with the cause and the fix that worked. Add new entries here when a PR runs into something new.

## Tooling

### melos stops with `StdinException: Error getting terminal echo mode`

melos shows an interactive package picker, which fails without a terminal. Add `--no-select` to every `melos run`, as CI does.

### melos cannot find the Flutter SDK in a new worktree

A fresh worktree has no `.fvm/flutter_sdk` link. Export `MELOS_SDK_PATH="$HOME/fvm/versions/$(jq -r .flutter .fvmrc)"` before running melos.

### Tests print `Waiting for another flutter command to release the startup lock...`

`melos run test` starts `flutter test` in many packages at once, and melos prefixes their stderr with `ERROR:`. These lines are lock waits; the result is the `All tests passed!` or failure line of each package.

### patrol fails after a patrol bump

A patrol release can require a newer `patrol_cli` than the globally activated one. Check `patrol --version` against the requirement in the patrol CHANGELOG, then ask the user before running `dart pub global activate patrol_cli <version>`.

### `rm -rf` is refused

`.claude/settings.json` denies `rm -rf`. Delete one target at a time with `rm -r <path>`, after checking what the path is.

## Disk

### `No space left on device` during a build

Builds need several GB. List the large directories with their sizes, propose what to delete, and wait for the user's decision. Check before each deletion:

- `~/Library/Developer/Xcode/iOS DeviceSupport`: keep the folder of the iPhone currently in use (`xcrun devicectl list devices`); the others are recreated when that device connects again.
- Simulators on runtimes that are no longer installed: delete them one by one with `xcrun simctl delete <udid>` (moving their folders leaves CoreSimulator's list out of sync).
- `~/Library/Developer/Xcode/DerivedData`: build caches. Check that no Xcode or xcodebuild is running first. To delete a single project's folder, match `WorkspacePath` in its `info.plist`.
- `~/.gradle/caches/<version>`: other projects and running Android Studio daemons may still use any version. Check with `grep -rho 'gradle-[0-9.]*-\(all\|bin\)' --include=gradle-wrapper.properties ~/work` and `ps` before deleting.

## iOS

### `Package.resolved` changes after an iOS build

`flutter build ios` first runs `xcodebuild -resolvePackageDependencies` in `ios/` without `-workspace` (`prefetchSwiftPackages` in flutter_tools), which resolves against `Runner.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`. The build itself uses `Runner.xcworkspace/xcshareddata/swiftpm/Package.resolved`. When the two copies pin different versions, Xcode re-resolves and rewrites the workspace copy on every clean build. Keep both copies identical, and include `Package.resolved` changes that a bump really needs in the PR.

To check: remove `packages/app/build/ios` and the worktree's DerivedData folder, build, and confirm `git status` stays clean.

### A plugin moved to Swift Package Manager and `RunnerUITests` cannot find it

Seen with patrol 4.7: `Module 'patrol' not found` in `RunnerUITests.m`. Link `FlutterGeneratedPluginSwiftPackage` to the `RunnerUITests` target in `project.pbxproj` and update both `Package.resolved` copies.

### The Crashlytics upload phase cannot find its `run` script

`flutter build ios` uses `-clonedSourcePackagesDirPath build/ios/SourcePackages`, so the script lives there and not under DerivedData. The build phase looks in both places. `flutterfire configure` regenerates this phase and drops the lookup, so recheck it after running that command.

### The release build log shows the dev bundle ID with `prod.env`

flutter prints the bundle ID from the previous build's `ios/Flutter/Dart-Defines.xcconfig` before the scheme pre-action rewrites it. Check the built app instead:

```bash
/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' build/ios/iphoneos/Runner.app/Info.plist
```

### Debug builds do not run on the iPhone

The connected iPhone (iOS 27) runs release builds only. Use the simulator for debug runs.

## Android

### Kotlin metadata errors after a Firebase bump

`Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 2.4.0, expected version is 2.2.0.` A new Firebase BoM ships libraries built with a newer Kotlin. Raise the Firebase BoM to the version the FlutterFire plugins build against and the Kotlin Gradle plugin to one that reads that metadata, and drop `kotlinOptions { jvmTarget }` when the new Kotlin rejects it.

The release APK can still print a few `e:` lines of this kind from `play-services-measurement` while the build succeeds; check the final `✓ Built` line.

### The emulator check uses a stale app

Uninstall `com.naipaka.onepage.dev` before installing, and trust the run only after the install reports success. Uninstalling also removes the app's data on that emulator.

## GitHub

### CI fails at `dart pub get --enforce-lockfile`

Dependabot resolves dependencies with the latest stable Flutter, which can be newer than `.fvmrc`. The lockfile then pins SDK-bundled packages to versions the pinned Flutter does not allow. Seen in #324: Flutter 3.50.0 wrote `test` 1.32.0, `test_api` 0.7.14, and `test_core` 0.6.20, while Flutter 3.47.2 pins `test_api` 0.7.12.

Run `fvm dart pub get --enforce-lockfile` in the worktree to reproduce, then set those packages back to the versions the pinned Flutter resolves (`fvm flutter pub get` on `main` shows them) and commit the lockfile. This repeats on every Dependabot PR until `.fvmrc` catches up with the latest stable Flutter; mention that in the report.

### CI jobs are cancelled

When an earlier run of the same jobs was green, rerun only the cancelled jobs.

### `git push` fails with `Permission denied (publickey)` or commit signing fails

Signing and SSH go through 1Password. Ask the user to unlock it, and check GitHub's status page for an incident before blaming the local setup.

### Dependabot rebased the branch after a commit was pushed

`git ls-remote` shows a different head. Fetch the new head, re-apply the commit on top of it, and verify again before pushing.
