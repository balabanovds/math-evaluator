import 'package:MathEvaluator/operand.dart';
import 'package:MathEvaluator/operator.dart';
import 'package:MathEvaluator/stack.dart';
import 'package:MathEvaluator/token.dart';

class PostfixNotation {
  final List<Token> tokens;

  PostfixNotation(this.tokens);

  List<Object> prepare(Map<String, double> variables) {
    Stack<Operator> operators = Stack();
    Stack<Object> out = Stack();

    Token pprev;
    Token prev;
    Token cur;

    double Function(Token) takeValue = (Token t) {
      if (t.type == TokenType.value) {
        return double.parse(t.value);
      }

      if (t.type == TokenType.variable) {
        if (!variables.containsKey(t.value)) {
          throw Exception('variable ${t.value} not provided');
        }
        return variables[t.value]!;
      }

      throw Exception('wrong token type ${t.type}');
    };

    for (var i = 0; i < tokens.length; i++) {
      cur = tokens[i];

      // Take first argument in expression.
      if (i == 0) {
        if (!cur.validAsFirst()) {
          throw Exception('first token is not valid');
        }

        if (cur.isOperand()) {
          out.push(Operand(takeValue(cur), false));
        } else {
          // If it is operand we put in stack.
          operators.push(Operator(cur.type));
        }

        continue;
      }

      // Validate last argument in expression.
      if (i == tokens.length - 1 && !cur.validAsLast()) {
        throw Exception('last token is not valid');
      }

      prev = tokens[i - 1];

      // Обрабатываем унарный оператор.
      if (i > 1 && prev.type == TokenType.sub && cur.isOperand()) {
        if (i == 1) {
          out.push(Operand(takeValue(cur), true));
        } else {
          pprev = tokens[i - 2];

          if (pprev.type != TokenType.rbr &&
              pprev.type != TokenType.value &&
              pprev.type != TokenType.variable) {
            out.push(Operand(takeValue(cur), true));
          }
        }

        continue;
      }

      /*
        Если при разборе строки нам встретилось число, то помещаем его в выходную строку
      */
      if (cur.isOperand()) {
        out.push(Operand(takeValue(cur), false));

        if (i == tokens.length - 1) {
          out.pushMany(operators.popAll());
        }
        continue;
      }

      var currentOperator = Operator(cur.type);

      /*
        Если в стеке пусто, или нам попалась открывающая скобка — помещаем оператор в стек
      */
      if (operators.length == 0 || cur.type == TokenType.lbr) {
        operators.push(currentOperator);
        continue;
      }

      /*
        Если строка закончилась — выталкиваем все операторы из стека в строку вывода
      */
      if (i == tokens.length - 1) {
        out.pushMany(operators.popAll());
      }

      /*
        Если нам попалась не скобка, а любой другой оператор, то выталкиваем из стека, в выходную строку, 
        операторы с бОльшим, или равным приоритетом. 
        Если, при выталкивании из стека, нам попался оператор с мЕньшим приоритетом — останавливаемся.
        Добавляем оператор на вершину стека.
       */
      if (cur.type != TokenType.lbr && cur.type != TokenType.rbr) {
        List<Operator> popped = operators.popLastElementsMatch(
            (o) => o.priority() < currentOperator.priority());
        out.pushMany(popped);
        operators.push(currentOperator);
        continue;
      }

      /*
        Если нам попалась закрывающая скобка, то выталкиваем из стека, в выходную строку, 
        все операторы до первой открывающей скобки. Открывающую скобку из стека удаляем.
       */
      if (cur.type == TokenType.rbr) {
        List<Operator> popped =
            operators.popLastElementsUnless((o) => o.isRbracket());
        operators.pop();
        out.pushMany(popped);
      }
    }

    return out.stack;
  }
}
