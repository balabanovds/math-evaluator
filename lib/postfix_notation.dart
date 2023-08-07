import 'package:MathEvaluator/operand.dart';
import 'package:MathEvaluator/operator.dart';
import 'package:MathEvaluator/token.dart';

class PostfixNotation {
  final List<Token> tokens;

  PostfixNotation(this.tokens);

  List<dynamic> prepare(Map<String, double> variables) {
    List<Operator> stack = List.empty(growable: true);
    List<dynamic> out = List.empty(growable: true);

    Token pprev;
    Token prev;
    Token cur;

    for (var i = 0; i < tokens.length; i++) {
      cur = tokens[i];

      double Function() takeValue = () {
        if (cur.type == TokenType.value) {
          return double.parse(cur.value);
        }

        if (cur.type == TokenType.variable) {
          if (!variables.containsKey(cur.value)) {
            throw Exception('variable ${cur.value} not provided');
          }
          return variables[cur.value]!;
        }

        throw Exception('wrong token type ${cur.type}');
      };

      // Take first argument in expression.
      if (i == 0) {
        if (!cur.validAsFirst()) {
          throw Exception('first token is not valid');
        }

        if (cur.isOperand()) {
          out.add(Operand(takeValue(), false));
        } else {
          // If it is operand we put in stack.
          stack.add(Operator(cur.type));
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
          out.add(Operand(takeValue(), true));
        } else {
          pprev = tokens[i - 2];

          if (pprev.type != TokenType.rbr &&
              pprev.type != TokenType.value &&
              pprev.type != TokenType.variable) {
            out.add(Operand(takeValue(), true));
          }
        }

        continue;
      }

      /*
        Если при разборе строки нам встретилось число, то помещаем его в выходную строку
      */
      if (cur.isOperand()) {
        out.add(Operand(takeValue(), false));
        continue;
      }

      var currentOperator = Operator(cur.type);

      /*
        Если в стеке пусто, или нам попалась открывающая скобка — помещаем оператор в стек
      */
      if (stack.length == 0 || cur.type == TokenType.lbr) {
        stack.add(currentOperator);
      }

      /*
        Если нам попалась не скобка, то выталкиваем из стека, в выходную строку, 
        операторы с бОльшим, или равным приоритетом. 
        Если, при выталкивании из стека, нам попался оператор с мЕньшим приоритетом — останавливаемся.
        Добавляем оператор на вершину стека.
       */
      if (cur.type != TokenType.lbr && cur.type != TokenType.rbr) {
        List<Operator> reversedStack = List.from(stack.reversed);
        while (reversedStack.length > 0) {
          var last = reversedStack.last;
          if (last.priority() < currentOperator.priority()) {
            break;
          }
          reversedStack.removeLast();
          out.add(last);
        }

        stack = List.from(reversedStack.reversed);
        stack.add(currentOperator);
      }

      /*
        Если нам попалась закрывающая скобка, то выталкиваем из стека, в выходную строку, 
        все операторы до первой открывающей скобки. Открывающую скобку из стека удаляем.
       */
      if (cur.type == TokenType.rbr) {
        List<Operator> reversedStack = List.from(stack.reversed);
        while (reversedStack.length > 0) {
          var last = reversedStack.removeLast();
          if (last.isRbracket()) {
            break;
          }
          out.add(last);
        }

        stack = List.from(reversedStack);
      }
    }

    return out;
  }
}
