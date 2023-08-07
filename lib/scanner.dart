import 'package:MathEvaluator/token.dart';

class Scanner {
  final String _string;

  Scanner(this._string) {}

  List<Token> tokenize() {
    List<Token> list = List.empty(growable: true);

    for (int i = 0; i < this._string.length; i++) {
      Token currentToken = Token(this._string[i]);

      if (i > 0) {
        var lastToken = list.last;
        if (currentToken.canBeMultiChar() &&
            currentToken.type == lastToken.type) {
          lastToken.merge(currentToken);
          continue;
        }
      }

      list.add(currentToken);
    }

    return list;
  }
}
