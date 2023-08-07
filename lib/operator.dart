import 'package:MathEvaluator/token.dart';

class Operator {
  late _OperatorType type;

  Operator(TokenType typ) {
    this.type = _parse(typ);
  }

  int priority() {
    switch (type) {
      case _OperatorType._lbr:
        return -1;
      case _OperatorType._rbr:
        return 0;
      case _OperatorType._add:
      case _OperatorType._sub:
        return 1;
      case _OperatorType._mul:
      case _OperatorType._div:
        return 2;
    }
  }

  double calculate(double left, double right) {
    switch (type) {
      case _OperatorType._add:
        return left + right;
      case _OperatorType._sub:
        return left - right;
      case _OperatorType._mul:
        return left * right;
      case _OperatorType._div:
        return left / right;
      default:
        return 0.0;
    }
  }

  bool isRbracket() {
    return type == _OperatorType._rbr;
  }

  _OperatorType _parse(TokenType typ) {
    switch (typ) {
      case TokenType.add:
        return _OperatorType._add;
      case TokenType.sub:
        return _OperatorType._sub;
      case TokenType.mul:
        return _OperatorType._mul;
      case TokenType.div:
        return _OperatorType._div;
      case TokenType.lbr:
        return _OperatorType._lbr;
      case TokenType.rbr:
        return _OperatorType._rbr;
      default:
        throw Exception('failed to parse operator ${typ.toString()}');
    }
  }
}

enum _OperatorType {
  _add,
  _sub,
  _mul,
  _div,
  _rbr,
  _lbr,
}
