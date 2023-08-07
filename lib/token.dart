class Token {
  late TokenType type;
  late String value;

  Token(String s) {
    this.type = _parseType(s);
    this.value = s;
  }

  @override
  bool operator ==(Object other) {
    return other is Token &&
        other.runtimeType == runtimeType &&
        other.type == type &&
        other.value == value;
  }

  @override
  int get hashCode => value.hashCode + type.hashCode;

  bool canBeMultiChar() {
    return type == TokenType.value || type == TokenType.variable;
  }

  bool isOperand() {
    return type == TokenType.value || type == TokenType.variable;
  }

  void merge(Token other) {
    if (type != other.type) {
      return;
    }

    value = value + other.value;
  }

  bool validAsFirst() {
    switch (type) {
      case TokenType.rbr:
      case TokenType.add:
      case TokenType.div:
      case TokenType.mul:
        return false;
      default:
        return true;
    }
  }

  bool validAsLast() {
    switch (type) {
      case TokenType.rbr:
      case TokenType.value:
      case TokenType.variable:
        return true;
      default:
        return false;
    }
  }

  TokenType _parseType(String s) {
    switch (s) {
      case "+":
        return TokenType.add;
      case "-":
        return TokenType.sub;
      case "*":
        return TokenType.mul;
      case "/":
        return TokenType.div;
      case "(":
        return TokenType.lbr;
      case ")":
        return TokenType.rbr;
    }

    RegExp alpha = RegExp(r'[a-zA-Z]+');
    if (alpha.hasMatch(s)) {
      return TokenType.variable;
    }

    RegExp dig = RegExp(r'\d+');
    if (dig.hasMatch(s)) {
      return TokenType.value;
    }

    return TokenType.unknown;
  }
}

enum TokenType {
  unknown,
  add,
  sub,
  mul,
  div,
  rbr,
  lbr,
  variable,
  value;
}
