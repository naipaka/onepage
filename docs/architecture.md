# Architecture

One Page is split into packages by feature inside a single Pub Workspaces monorepo managed with Melos.
Placement rules for day-to-day work live in [`.claude/rules/architecture.md`](../.claude/rules/architecture.md).

## Structure

```
packages/
├── app/        Pages, routing, and the adapters that wrap core and features in Riverpod providers
├── core/       Foundations shared across the app: clients for platform SDKs, the database, i18n, theme, shared widgets
└── features/   One package per feature: diary, backup, exporter, photo recovery, and so on
```

- `features` packages depend only on `core` packages.
- `app` depends on both and is the only place where features are combined.
- Except for `provider_utils`, `core` and `features` do not use Riverpod. Their classes take what they need as constructor arguments.
- `app/lib/adapters` wraps those classes in `@riverpod` providers, and the pages read the providers.

The [dependency graph](./dependency_graph.svg) shows the current state; a GitHub Actions workflow regenerates it whenever the dependencies change on `main`.

## Why packages

Every package declares its dependencies in its own `pubspec.yaml`, and Dart only lets a package import what it declares.
The build checks the architecture:

- The direction of every dependency is visible in the pubspec files and in the graph.
- Code that reaches across a boundary does not compile, whoever wrote it.
- The app is assembled in `app` from these packages.

Splitting into packages costs extra files and boilerplate. Pub Workspaces resolves the whole repository with one lockfile, and most of the code here is written with AI coding agents, so that cost stays small.

## What it gives us

### Boundaries hold without relying on review

- A feature cannot import another feature.
- Code that combines features lives in the `app` pages and adapters, which makes it easy to find where two features meet.

### Platform SDKs sit behind small core clients

- Notifications (`notification_client`), Analytics and Crashlytics (`tracker`), Remote Config (`configurator`), SharedPreferences (`prefs_client`), and the database (`db_client`) each have their own package.
- Each core package wraps one thing.
- Updating one of these SDKs mostly touches its client package.
- Packages that only one feature needs, such as `in_app_review` or `printing`, stay inside that feature.

### Tests do not depend on Riverpod

- `core` and `features` tests construct the classes directly and never touch Riverpod.
- Provider overrides appear only in the `app` tests.
- Upgrading Riverpod affects `app` and `provider_utils` and leaves the rest of the tests alone.

### Mistakes in placement fail the build

- Code placed in the wrong package or depending in the wrong direction fails to build.
- The placement rules in `.claude/rules/architecture.md` give agents a test for where new code goes: "Can this widget/code be used as-is in a completely different app (not a diary app)?"
- Lints from altive_lints catch common mistakes such as hardcoded Japanese text or colors.

## Conventions

### Features expose operations; `app` holds state

Features expose plain classes (for example `DiaryQuery` and `DiaryCommand`) that return `Future` and `Stream`, and some also ship widgets.
The Riverpod notifiers in `app/lib/adapters` keep what the screens show: loaded entries, paging, and optimistic updates.
Business rules belong in the feature's classes, where they can be tested without Riverpod.

### `core` holds what several parts build on

A package goes in `core` when it is independent of this app's domain or when several features depend on it.
`db_client` is in `core` because `diary`, `backup`, `exporter`, and `photo_recovery` all use it.

### The database stays in `db_client`

Features use the entry types `db_client` exposes. Feature code never imports `drift`.

### Native code lives in plugin packages

Create them with the `create-package` skill.

### Rules are written down and linted

`.claude/rules/` holds the written rules, and altive_lints enforces the ones that can be checked mechanically.
