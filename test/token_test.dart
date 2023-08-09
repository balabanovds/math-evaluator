import 'package:MathEvaluator/token.dart';
import 'package:test/test.dart';
import 'run.dart';

class _TestCaseParse implements Runnable {
  _TestCaseParse(this.name, this.incoming, this.wantTokenType);

  final String name;
  final String incoming;
  final TokenType wantTokenType;

  @override
  void run() {
    test('parsing $name', () {
      final Token t = Token(incoming);
      expect(t.type, equals(wantTokenType));
      expect(t.value, equals(incoming));
    });
  }
}

class _TestCaseMultichar implements Runnable {
  _TestCaseMultichar(this.name, this.incoming, this.want);

  final String name;
  final String incoming;
  final bool want;

  @override
  void run() {
    final String testName =
        want ? '$name can be multichar' : '$name cannot be multichar';
    test(testName, () {
      final Token t = Token(incoming);
      expect(t.canBeMultiChar(), equals(want));
    });
  }
}

class _TestCaseValidAsFirst implements Runnable {
  _TestCaseValidAsFirst(this.name, this.token, this.wantValid);

  final String name;
  final Token token;
  final bool wantValid;

  @override
  void run() {
    final String testName =
        wantValid ? 'valid as first $name' : 'not valid as first $name';
    test(testName, () {
      expect(token.validAsFirst(), equals(wantValid));
    });
  }
}

class _TestCaseValidAsLast implements Runnable {
  _TestCaseValidAsLast(this.name, this.token, this.wantValid);

  final String name;
  final Token token;
  final bool wantValid;

  @override
  void run() {
    final String testName =
        wantValid ? 'valid as last $name' : 'not valid as last $name';
    test(testName, () {
      expect(token.validAsLast(), equals(wantValid));
    });
  }
}

void main() {
  group('Token', () {
    final List<Runnable> runnables = List<Runnable>.empty(growable: true);

    runnables.addAll(<_TestCaseParse>[
      _TestCaseParse('add', '+', TokenType.add),
      _TestCaseParse('sub', '-', TokenType.sub),
      _TestCaseParse('div', '/', TokenType.div),
      _TestCaseParse('mul', '*', TokenType.mul),
      _TestCaseParse('left bracket', '(', TokenType.lbr),
      _TestCaseParse('right bracket', ')', TokenType.rbr),
      _TestCaseParse('variable x', 'x', TokenType.variable),
      _TestCaseParse('variable AA', 'AA', TokenType.variable),
      _TestCaseParse('value 10', '10', TokenType.value),
      _TestCaseParse('unknown "^"', '^', TokenType.unknown),
    ]);

    runnables.addAll(<_TestCaseMultichar>[
      _TestCaseMultichar('add', '+', false),
      _TestCaseMultichar('sub', '-', false),
      _TestCaseMultichar('div', '/', false),
      _TestCaseMultichar('mul', '*', false),
      _TestCaseMultichar('left bracket', '(', false),
      _TestCaseMultichar('right bracket', ')', false),
      _TestCaseMultichar('variable', 'x', true),
      _TestCaseMultichar('value', '1', true),
    ]);

    runnables.addAll(<_TestCaseValidAsFirst>[
      _TestCaseValidAsFirst('10', Token('10'), true),
      _TestCaseValidAsFirst('x', Token('x'), true),
      _TestCaseValidAsFirst('(', Token('('), true),
      _TestCaseValidAsFirst('-', Token('-'), true),
      _TestCaseValidAsFirst('+', Token('+'), false),
      _TestCaseValidAsFirst('/', Token('/'), false),
      _TestCaseValidAsFirst('*', Token('*'), false),
      _TestCaseValidAsFirst(')', Token(')'), false),
    ]);

    runnables.addAll(<_TestCaseValidAsLast>[
      _TestCaseValidAsLast('10', Token('10'), true),
      _TestCaseValidAsLast('x', Token('x'), true),
      _TestCaseValidAsLast(')', Token(')'), true),
      _TestCaseValidAsLast('(', Token('('), false),
      _TestCaseValidAsLast('-', Token('-'), false),
      _TestCaseValidAsLast('+', Token('+'), false),
      _TestCaseValidAsLast('/', Token('/'), false),
      _TestCaseValidAsLast('*', Token('*'), false),
    ]);

    run(runnables);
  });
}
