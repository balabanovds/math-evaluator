import 'package:test/test.dart';
import 'package:MathEvaluator/token.dart';

class _TestCaseParse {
  final String name;
  final String incoming;
  final TokenType wantTokenType;

  _TestCaseParse(this.name, this.incoming, this.wantTokenType) {}

  run() {
    test('parsing ${name}', () {
      Token t = Token(incoming);
      expect(t.type, equals(wantTokenType));
      expect(t.value, equals(incoming));
    });
  }
}

class _TestCaseMultichar {
  final String name;
  final String incoming;
  final bool want;

  _TestCaseMultichar(this.name, this.incoming, this.want) {}

  run() {
    String testName =
        want ? '${name} can be multichar' : '${name} cannot be multichar';
    test(testName, () {
      Token t = Token(incoming);
      expect(t.canBeMultiChar(), equals(want));
    });
  }
}

class _TestCaseValidAsFirst {
  final String name;
  final Token token;
  final bool wantValid;

  _TestCaseValidAsFirst(this.name, this.token, this.wantValid) {}

  run() {
    String testName =
        wantValid ? 'valid as first $name' : 'not valid as first $name';
    test(testName, () {
      expect(token.validAsFirst(), equals(wantValid));
    });
  }
}

class _TestCaseValidAsLast {
  final String name;
  final Token token;
  final bool wantValid;

  _TestCaseValidAsLast(this.name, this.token, this.wantValid) {}

  run() {
    String testName =
        wantValid ? 'valid as last $name' : 'not valid as last $name';
    test(testName, () {
      expect(token.validAsLast(), equals(wantValid));
    });
  }
}

void main() {
  group('Token', () {
    {
      List<_TestCaseParse> tests = [
        _TestCaseParse('add', "+", TokenType.add),
        _TestCaseParse('sub', "-", TokenType.sub),
        _TestCaseParse('div', "/", TokenType.div),
        _TestCaseParse('mul', "*", TokenType.mul),
        _TestCaseParse('left bracket', "(", TokenType.lbr),
        _TestCaseParse('right bracket', ")", TokenType.rbr),
        _TestCaseParse('variable x', 'x', TokenType.variable),
        _TestCaseParse('variable AA', 'AA', TokenType.variable),
        _TestCaseParse('value 10', '10', TokenType.value),
        _TestCaseParse('unknown "^"', '^', TokenType.unknown),
      ];

      tests.forEach((test) => test.run());
    }

    {
      List<_TestCaseMultichar> tests = [
        _TestCaseMultichar('add', '+', false),
        _TestCaseMultichar('sub', '-', false),
        _TestCaseMultichar('div', '/', false),
        _TestCaseMultichar('mul', '*', false),
        _TestCaseMultichar('left bracket', "(", false),
        _TestCaseMultichar('right bracket', ")", false),
        _TestCaseMultichar('variable', 'x', true),
        _TestCaseMultichar('value', '1', true),
      ];

      tests.forEach((test) => test.run());
    }

    {
      List<_TestCaseValidAsFirst> tests = [
        _TestCaseValidAsFirst('10', Token('10'), true),
        _TestCaseValidAsFirst('x', Token('x'), true),
        _TestCaseValidAsFirst('(', Token('('), true),
        _TestCaseValidAsFirst('-', Token('-'), true),
        _TestCaseValidAsFirst('+', Token('+'), false),
        _TestCaseValidAsFirst('/', Token('/'), false),
        _TestCaseValidAsFirst('*', Token('*'), false),
        _TestCaseValidAsFirst(')', Token(')'), false),
      ];

      tests.forEach((test) => test.run());
    }

    {
      List<_TestCaseValidAsLast> tests = [
        _TestCaseValidAsLast('10', Token('10'), true),
        _TestCaseValidAsLast('x', Token('x'), true),
        _TestCaseValidAsLast(')', Token(')'), true),
        _TestCaseValidAsLast('(', Token('('), false),
        _TestCaseValidAsLast('-', Token('-'), false),
        _TestCaseValidAsLast('+', Token('+'), false),
        _TestCaseValidAsLast('/', Token('/'), false),
        _TestCaseValidAsLast('*', Token('*'), false),
      ];

      tests.forEach((test) => test.run());
    }
  });
}
