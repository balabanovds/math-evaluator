import 'operand.dart';
import 'operator.dart';
import 'postfix_notation.dart';
import 'scanner.dart';
import 'stack.dart';
import 'token.dart';

class Math {
  Math(this._expression);

  final String _expression;

  double eval(Map<String, double> variables) {
    final List<Token> tokens = _tokenize();

    final Stack<double> stack = Stack<double>();
    PostfixNotation(tokens).prepare(variables).forEach((Object e) {
      if (e is Operand) {
        stack.push(e.value());
        return;
      }

      if (e is Operator) {
        final double right = stack.pop();
        final double left = stack.pop();

        stack.push(e.calculate(left, right));
      }
    });

    if (stack.length != 1) {
      throw Exception('invalid math expression');
    }

    return stack.pop();
  }

  List<Token> _tokenize() {
    return Scanner(_expression).tokenize();
  }
}
