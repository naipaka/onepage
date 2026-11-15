import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';

import '../rules/prefer_clock_now.dart';

/// {@template one_page_lints.ReplaceWithClockNow}
/// Replaces `DateTime.now()` with `clock.now()`, and `DateTime.timestamp()`
/// with `clock.now().toUtc()`, importing package:clock.
///
/// The fix is offered only when package:clock is available to the file. When
/// the file declares another `clock`, package:clock is imported with a prefix.
/// {@endtemplate}
class ReplaceWithClockNow extends ResolvedCorrectionProducer {
  /// {@macro one_page_lints.ReplaceWithClockNow}
  new({required super.context});

  static const _kind = FixKind(
    'one_page_lints.fix.replaceWithClockNow',
    DartFixKindPriority.standard,
    "Replace with 'clock.now()'",
  );

  static final _clockLibrary = Uri.parse('package:clock/clock.dart');

  static const _clockName = 'clock';

  @override
  CorrectionApplicability get applicability => .singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final expression = node.thisOrAncestorOfType<InstanceCreationExpression>();
    if (expression == null || !isDateTimeNow(expression)) {
      return;
    }
    final library = await unitResult.session.getLibraryByUri(
      _clockLibrary.toString(),
    );
    final clock = library is LibraryElementResult
        ? library.element.exportNamespace.get2(_clockName)
        : null;
    if (clock == null) {
      return;
    }
    final declaresClock =
        (_ClockDeclarationFinder()..visitCompilationUnit(
              unit,
            ))
            .found;
    final isTimestamp = expression.constructorName.name?.name == 'timestamp';
    await builder.addDartFileEdit(file, (builder) {
      if (declaresClock) {
        builder.importLibrary(_clockLibrary, prefix: 'clock_package');
      }
      builder.addReplacement(range.node(expression), (builder) {
        builder
          ..writeReference(clock)
          ..write(isTimestamp ? '.now().toUtc()' : '.now()');
      });
    });
  }
}

class _ClockDeclarationFinder extends RecursiveAstVisitor<void> {
  bool found = false;

  void _check(Token? name) {
    if (name?.lexeme == ReplaceWithClockNow._clockName) {
      found = true;
    }
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    _check(node.name);
    super.visitVariableDeclaration(node);
  }

  @override
  void visitFormalParameterList(FormalParameterList node) {
    node.parameters.map((parameter) => parameter.name).forEach(_check);
    super.visitFormalParameterList(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    _check(node.name);
    super.visitMethodDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _check(node.name);
    super.visitFunctionDeclaration(node);
  }
}
