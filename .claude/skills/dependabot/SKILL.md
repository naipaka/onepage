---
name: dependabot
description: Handle one open Dependabot PR from start to merge - read what the bump changes in the changelog, package source, and upstream git log, explain every change and the planned responses to the user, then regenerate code, verify the affected flows on a device, update the PR when something needs fixing, and report everything to the user in Japanese. Use when the user asks to handle, check, or update a Dependabot PR.
argument-hint: "[PR number]"
---

# Dependabot PR Handling

Each run handles one Dependabot PR and ends after the user merges it and the worktree is cleaned up. The next PR gets a new run of this skill.

Read `references/troubleshooting.md` when anything fails or looks off; it lists every problem met so far and how it was solved.

## Rules

- Run every check that applies. A long check runs in the background; it is never a reason to skip one.
- Look things up before asserting them. Read the package source, upstream docs, or the web for platform facts, error causes, and service status. When something blocks the lookup, say what blocked it and ask.
- Explain what changed before any work. Steps 1–3 only read. Agreeing on the PR in step 1 is agreement on which PR to look at; worktrees, fixes, and checks start after the user agrees to the responses explained in step 3.
- Fix every problem found in the PR being handled, including problems that predate it, so the PR is mergeable when you report.
- Ask before changing global tools (`dart pub global activate`, SDKs, system images), deleting anything outside the worktree, or closing a PR.
- Start from a clean state. Worktrees, branches, and uncommitted changes left by an earlier session are never reused: report them to the user and recreate the worktree after the user has them removed.
- Keep Dependabot's title and body. Explain added commits in a PR comment.
- Run commands in the background by default, each with a `timeout` sized to the job. Never wait on one in the foreground; the completion notification brings you back.
- Report only after the PR's CI has finished, with the result of every check.

## 1. Decide the PR

When `$ARGUMENTS` names a PR, handle that one and read what it bumps:

```bash
gh pr view <N> --json title,headRefName,baseRefOid,mergeable,statusCheckRollup
gh pr diff <N>    # versions in pubspec.yaml and pubspec.lock, including transitive ones
```

When `$ARGUMENTS` is empty, list the open PRs, read each one's diff, propose an order, and agree with the user on the one PR to handle in this run:

```bash
gh pr list --author app/dependabot --state open \
  --json number,title,headRefName,mergeable,files
```

- Small, single-package patch bumps first.
- Group PRs and PRs that touch the same `pubspec.yaml` back to back.
- Major bumps and PRs with native-side changes last.
- A PR that makes another one unnecessary goes first.

Group names do not limit the bump size: a `dependencies-patch` group can contain majors.

## 2. Read what changed

For each bumped package, including transitive ones in `pubspec.lock`:

- Read the CHANGELOG entries for every version in between.
- Diff the package source. Old versions are in the pub cache from `main`; download missing new versions into the cache with `fvm dart pub cache add <pkg> --version <new>`:

  ```bash
  cd ~/.pub-cache/hosted/pub.dev && diff -ru <pkg>-<old> <pkg>-<new>
  ```

  Read `lib/`, `pubspec.yaml` (SDK and Flutter constraints), and the native side (`ios/`, `darwin/`, `Package.swift`, `android/`, `build.gradle`).

- Read the upstream git log between the two release tags to find the pull requests behind each change: `gh api repos/<owner>/<repo>/compare/<old-tag>...<new-tag> --jq '.commits[].commit.message'`. The repository is in the package's `pubspec.yaml` (`repository` or `homepage`).
- For packages with native code, read upstream docs or source as well (`gh api repos/<owner>/<repo>/contents/<path>`).

Then map the changes onto this app:

- Find missed bump locations: `grep -rn '<pkg>' --include=pubspec.yaml .`
- Find usages: `grep -rn 'package:<pkg>' --include='*.dart' packages`, and the specific APIs that changed.
- Compare new SDK minimums with `.fvmrc` and `.github/actions/setup-flutter` (CI uses `.fvmrc`).
- Read the PR's failed CI jobs (`gh run view <run-id> --log-failed`) and find the cause.
- Decide the device checks from the changes that alter runtime behavior. Each check is an app flow that runs the changed code and that `melos run test` does not cover, such as navigation between real screens. When no change alters runtime behavior in a flow the app uses, there are no device checks. Examples:
  - `riverpod` fixing how paused subscriptions resume: open a screen over home and go back
  - `go_router` changing redirects: the navigation that goes through a redirect
  - `flutter_local_notifications` changing scheduling: scheduling and showing a reminder
- Check on one platform when the changed code has no platform-specific side, such as a pure Dart package; check both when the change is in native code or differs per platform.
- Run E2E only when its scenario goes through one of those flows.

## 3. Explain the changes and agree on the responses

Write in Japanese, one section per package:

- **変更内容**: every change between the two versions, whether or not it affects this app: new APIs, deprecations, behavior changes, bug fixes, new lint rules, constraint changes, native changes. Cite the changelog entry or upstream pull request for each.
- **このアプリへの影響**: the usages each change touches, or why it touches none.

Then list the responses this PR needs, each with what will be changed and why: fixes for failed CI jobs, code changes for deprecations or behavior changes, adopting new lint rules or APIs, missed bump locations. When none is needed, say so.

List the device checks decided in step 2, each with the flow, the platform, and the change it covers.

Wait for the user to agree on the responses before going on to step 4.

## 4. Prepare a worktree

Work in a worktree under the scratchpad directory so the main checkout stays on `main`.

```bash
df -h /System/Volumes/Data      # builds need several GB free
git worktree list               # a worktree already on pr-<N> is left over from an earlier session: report it and stop
D=<scratchpad>/pr-<N>
git fetch origin pull/<N>/head:pr-<N>
git worktree add "$D" pr-<N>
git fetch origin main
cd "$D" && git merge origin/main   # take in the PRs merged since Dependabot opened this one
fvm flutter pub get
```

Copy the git-ignored local files from the main checkout into the worktree (same relative paths):

- `packages/app/dart_defines/{dev,prod}.env`, `packages/app/firebase.json`
- `packages/app/lib/environment/src/firebase_options_{dev,prod}.dart`
- `packages/app/android/app/google-services.json`, `packages/app/android/app/src/{dev,prod}/google-services.json`
- `packages/app/android/key.properties`, `packages/app/android/local.properties`, `packages/app/android/app/upload-keystore.jks`
- `packages/app/ios/Flutter/Dart-Defines.xcconfig`, `packages/app/ios/Runner/GoogleService-Info.plist`, `packages/app/ios/firebase_app_id_file.json`
- `packages/app/ios/{dev,prod}/{GoogleService-Info.plist,firebase.json,firebase_app_id_file.json}`, `packages/app/ios/prod/UploadOptions.plist`

The worktree has no `.fvm/flutter_sdk` link, so pass the SDK to melos and always add `--no-select`:

```bash
export MELOS_SDK_PATH="$HOME/fvm/versions/$(jq -r .flutter .fvmrc)"
fvm dart run melos run <script> --no-select
```

Then make the responses agreed in step 3.

## 5. Regenerate code

```bash
fvm dart run melos run gen --no-select
fvm dart run melos run slang --no-select
git status --porcelain
```

A change limited to the `Built on` timestamp in `strings.g.dart` is noise: restore it with `git checkout --`. Any other diff is part of the PR.

## 6. Verify

Run from the worktree root:

```bash
fvm dart analyze                                   # No issues found!
fvm dart run melos run format:ci --no-select
fvm dart run melos run test --no-select            # every package passes
```

Device checks agreed in step 3, from `packages/app`:

- Other projects use simulators and emulators on this machine. Boot your own device, pass its id to every command (`-d <udid>`, `adb -s <id>`), and leave every other device untouched. Commands without a device id (`simctl shutdown all`, `adb kill-server`) are off limits.
- iOS simulator, debug, on the newest iOS runtime: `fvm flutter run -d <udid> --debug --dart-define-from-file=dart_defines/dev.env`
- Android emulator: `adb -s <id> uninstall com.naipaka.onepage.dev` first, then `fvm flutter run -d <id>`; trust the run only after the install succeeds.
- The connected iPhone runs release builds only; use it when the user asks or when a change needs a real device.
- Exercise only the agreed flows, and watch the console for exceptions and deprecation warnings.
- Each flow takes the shortest path that runs the changed code, and checks only the result after it that the change affects. Skip results another flow already checks.
- Read the screen with `axe describe-ui`. Take a screenshot only where `describe-ui` cannot read the screen (system pickers, share sheets) or for the final result of each flow, shrunk with `sips -Z 600`.
- Wait for the screen to settle (keyboard open, picker loaded) before each tap, so no tap has to be redone.
- E2E, when agreed: `patrol test -t patrol_test/example_test.dart --device <udid> --dart-define-from-file=dart_defines/dev.env`
- Release builds, only when the PR has a change that behaves differently in release: native code (`ios/`, `android/`, `Package.swift`, `build.gradle`), build settings or SDK constraints, or packages for code generation or compilation:

  ```bash
  fvm flutter build ios --release --no-codesign --dart-define-from-file=dart_defines/prod.env
  fvm flutter build apk --release --dart-define-from-file=dart_defines/prod.env
  ```

- After every iOS build, `git status --porcelain` must stay clean, and the two `Package.resolved` copies must be identical:

  ```bash
  cmp packages/app/ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved \
      packages/app/ios/Runner.xcworkspace/xcshareddata/swiftpm/Package.resolved
  ```

- Shut down every simulator and emulator you booted. Leave devices that were running before you started.

## 7. Update the PR

When something needs fixing:

1. Commit in the worktree. Message: `build(deps): <what changed>` with a body that explains the cause. The only scopes allowed are `deps` and real package names.
2. Check that Dependabot has not pushed meanwhile: `git ls-remote origin refs/heads/<head-branch>` must equal the worktree's base commit.
3. `git push origin HEAD:refs/heads/<head-branch>`
4. Post a comment in English with `gh pr comment <N> --body-file <file>`:

   ```markdown
   Added one commit on top of dependabot's.

   ### `<sha>` <Summary>

   <Symptom, cause, fix>

   ### Checked

   - <What changed in each package and why it does not affect the app>
   - `fvm dart analyze` → No issues found! / `melos run test` → all pass
   - <Builds and device checks, as a table when there are several>
   ```

When nothing needs fixing, push nothing. Rerun cancelled CI jobs if any.

Then wait for CI in the background and read every check's final state:

```bash
gh pr checks <N> --watch --fail-fast   # run with a timeout of about 30 minutes
gh pr checks <N>
```

A check that is still running is not a pass. Fix failures in this run.

## 8. Report to the user

Write in Japanese. Start with the conclusion: whether the PR can be merged as is, and what was pushed. Then:

- **対応したこと**: each response agreed in step 3 and the resulting diff
- **自動生成**: what was regenerated and the resulting diff
- **確認したこと**: each check and its result, with screenshot paths
- **この PR とは関係ないけれど見つけたこと**: problems found on the way, and how they were handled
- When English text was posted, add a Japanese version of it.

## 9. After the merge

Wait for the user to say the PR is merged, then confirm it and clean up:

```bash
gh pr view <N> --json state --jq .state   # MERGED
git worktree remove <scratchpad>/pr-<N>
git branch -D pr-<N>
```

End the run by reporting the cleanup and the remaining Dependabot PRs (`gh pr list --author app/dependabot --state open`) with the one recommended next. The next PR is handled in a new run of this skill.
