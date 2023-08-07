import 'package:MathEvaluator/operand.dart';
import 'package:MathEvaluator/operator.dart';
import 'package:MathEvaluator/postfix_notation.dart';
import 'package:MathEvaluator/scanner.dart';
import 'package:MathEvaluator/token.dart';

class Math {
  final String _expression;

  Math(this._expression) {}

  double eval(Map<String, double> variables) {
    var tokens = _tokenize();

    List<double> stack = List.empty(growable: true);
    PostfixNotation(tokens).prepare(variables).forEach((e) {
      if (e is Operand) {
        stack.add(e.value());
        return;
      }

      if (e is Operator) {
        var right = stack.removeLast();
        var left = stack.removeLast();

        stack.add(e.calculate(left, right));
      }
    });

    if (stack.length != 1) {
      throw Exception('invalid math expression');
    }

    return stack[0];
  }

  List<Token> _tokenize() {
    return Scanner(_expression).tokenize();
  }
}
