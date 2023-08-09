import 'package:MathEvaluator/scanner.dart';
import 'package:MathEvaluator/token.dart';
import 'package:test/test.dart';

import 'run.dart';

class _TestCaseScan implements Runnable {
  _TestCaseScan(this.name, this.incoming, this.want);

  final String name;
  final String incoming;
  final List<Token> want;

  @override
  void run() {
    final List<Token> got = Scanner(incoming).tokenize();

    test(name, () {
      expect(got, equals(want));
    });
  }
}

void main() {
  group('Scanning line', () {
    final List<_TestCaseScan> tests = <_TestCaseScan>[
      _TestCaseScan('1+1', '1+1', <Token>[Token('1'), Token('+'), Token('1')]),
      _TestCaseScan(
          '10*2', '10*2', <Token>[Token('10'), Token('*'), Token('2')]),
      _TestCaseScan('(10+x)/2', '(10+x)/2', <Token>[
        Token('('),
        Token('10'),
        Token('+'),
        Token('x'),
        Token(')'),
        Token('/'),
        Token('2')
      ]),
      _TestCaseScan('-1', '-1', <Token>[Token('-'), Token('1')]),
    ];

    run(tests);
  });
}
