import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/workspace/workspace.dart';

/// The ends of the names of the files that the generators of One Page write:
/// build_runner and slang write `.g.dart` files, and drift writes the schema
/// steps in `.steps.dart` files.
const _generatedSuffixes = ['.g.dart', '.steps.dart'];

/// The names of the generated files that have no generated suffix: patrol
/// writes `test_bundle.dart`.
const _generatedNames = {'test_bundle.dart'};

/// The start of the names of the Firebase options that FlutterFire CLI writes
/// for each flavor, such as `firebase_options_dev.dart`.
const _firebaseOptionsPrefix = 'firebase_options_';

/// The name of the folders that hold only generated files: drift writes the
/// test schemas in `generated`.
const _generatedFolder = 'generated';

/// Whether [file] of [package] is written by a generator, judged by its name
/// and the folders it is in inside the package.
bool isGeneratedFile(File file, WorkspacePackage? package) {
  final name = file.shortName;
  return _generatedSuffixes.any(name.endsWith) ||
      _generatedNames.contains(name) ||
      (name.startsWith(_firebaseOptionsPrefix) && name.endsWith('.dart')) ||
      folderNamesInPackage(file, package).contains(_generatedFolder);
}

/// The names of the folders that [file] is in, from the root of [package], or
/// from the root of the file system when it is in no package.
List<String> folderNamesInPackage(File file, WorkspacePackage? package) {
  final context = file.provider.pathContext;
  final folder = file.parent.path;
  final relative = package == null
      ? folder
      : context.relative(folder, from: package.root.path);
  return context.split(relative);
}
