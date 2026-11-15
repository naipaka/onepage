import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/file_system/file_system.dart';

import '../types.dart';

/// A type declaration that a macro template documents, and its name.
typedef TypeDeclaration = ({CompilationUnitMember node, Token name});

/// The type declaration that encloses [node]: a class, an enum, a mixin, an
/// extension type, or a type alias.
TypeDeclaration? enclosingTypeDeclaration(AstNode node) {
  final declaration = node.thisOrAncestorOfType<CompilationUnitMember>();
  final name = switch (declaration) {
    ClassDeclaration(:final namePart) ||
    EnumDeclaration(:final namePart) ||
    ExtensionTypeDeclaration(:final namePart) => namePart.typeName,
    MixinDeclaration(:final name) || TypeAlias(:final name) => name,
    _ => null,
  };
  if (declaration == null || name == null) {
    return null;
  }
  return (node: declaration, name: name);
}

/// The name of the package of [unitResult], which prefixes the macro names.
///
/// A file outside `lib` has no `package:` URI, so the name is read from the
/// nearest `pubspec.yaml`.
String? packageNameOfUnit(ResolvedUnitResult unitResult) {
  final fromUri = packageNameOf(unitResult.libraryElement.uri);
  if (fromUri != null) {
    return fromUri;
  }
  for (
    Folder? folder = unitResult.file.parent;
    folder != null;
    folder = folder.isRoot ? null : folder.parent
  ) {
    final pubspec = folder.getFile('pubspec.yaml');
    if (pubspec.exists) {
      return _pubspecName.firstMatch(pubspec.readAsStringSync())?.group(1);
    }
  }
  return null;
}

final _pubspecName = RegExp(r'^name:\s*(\w+)', multiLine: true);
