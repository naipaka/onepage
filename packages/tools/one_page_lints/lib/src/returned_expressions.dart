import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

/// The expressions that [body] returns, leaving out the returns of the
/// functions declared inside it.
List<Expression> returnedExpressions(FunctionBody body) => switch (body) {
  ExpressionFunctionBody(:final expression) => [expression],
  BlockFunctionBody(:final block) =>
    (_ReturnCollector()..visitBlock(
          block,
        ))
        .expressions,
  _ => const [],
};

class _ReturnCollector extends RecursiveAstVisitor<void> {
  final expressions = <Expression>[];

  @override
  void visitReturnStatement(ReturnStatement node) {
    if (node.expression case final expression?) {
      expressions.add(expression);
    }
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {}
}
