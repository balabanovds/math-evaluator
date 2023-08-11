import 'operand.dart';
import 'operator.dart';
import 'stack.dart';
import 'token.dart';

class PostfixNotation {
  PostfixNotation(this.tokens);

  final List<Token> tokens;

  List<Object> prepare(Map<String, double> variables) {
    final Stack<Operator> operators = Stack<Operator>();
    final Stack<Object> out = Stack<Object>();

    Token pprev;
    Token prev;
    Token cur;

    final double Function(Token) takeValue = (Token t) {
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

    for (int i = 0; i < tokens.length; i++) {
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
      if (cur.type == TokenType.sub &&
          (tokens.isEmpty || prev.type == TokenType.lbr)) {
        continue;
      }

      if (i > 1 && prev.type == TokenType.sub && cur.isOperand()) {
        if (i == 1) {
          out.push(Operand(takeValue(cur), true));
          continue;
        } else {
          pprev = tokens[i - 2];

          if (pprev.type != TokenType.rbr &&
              pprev.type != TokenType.value &&
              pprev.type != TokenType.variable) {
            out.push(Operand(takeValue(cur), true));
            continue;
          }
        }
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

      final Operator currentOperator = Operator(cur.type);

      /*
        Если в стеке пусто, или нам попалась открывающая скобка — помещаем оператор в стек
      */
      if (operators.length == 0 || cur.type == TokenType.lbr) {
        operators.push(currentOperator);
        continue;
      }

      /*
        Если нам попалась не скобка, а любой другой оператор, то выталкиваем из стека, в выходную строку, 
        операторы с бОльшим, или равным приоритетом. 
        Если, при выталкивании из стека, нам попался оператор с мЕньшим приоритетом — останавливаемся.
        Добавляем оператор на вершину стека.
       */
      if (cur.type != TokenType.lbr && cur.type != TokenType.rbr) {
        final List<Operator> popped = operators.popLastElementsMatch(
            (Operator o) => o.priority() >= currentOperator.priority());
        out.pushMany(popped);
        operators.push(currentOperator);
        continue;
      }

      /*
        Если нам попалась закрывающая скобка, то выталкиваем из стека, в выходную строку, 
        все операторы до первой открывающей скобки. Открывающую скобку из стека удаляем.
       */
      if (cur.type == TokenType.rbr) {
        final List<Operator> popped =
            operators.popLastElementsUnless((Operator o) => o.isLbracket());
        operators.pop();
        out.pushMany(popped);

        if (i == tokens.length - 1) {
          out.pushMany(operators.popAll());
        }
      }
    }

    return out.stack;
  }
}
