import 'token.dart';

class Scanner {
  Scanner(this._string);

  final String _string;

  List<Token> tokenize() {
    final List<Token> list = List<Token>.empty(growable: true);

    for (int i = 0; i < _string.length; i++) {
      final Token currentToken = Token(_string[i]);

      if (i > 0) {
        final Token lastToken = list.last;
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
