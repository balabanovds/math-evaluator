import 'package:MathEvaluator/postfix_notation.dart';
import 'package:MathEvaluator/token.dart';

import 'run.dart';
import 'package:test/test.dart';

class _TestCasePrepare implements Runnable {
  _TestCasePrepare(this.name, this.incoming, this.variables, this.want);

  final String name;
  final List<Token> incoming;
  final Map<String, double> variables;
  final String want;

  @override
  void run() {
    test('prepare $name', () {
      var pn = PostfixNotation(incoming);

      var got = pn.prepare(variables);

      expect(string(got), equals(want));
    });
  }
}

void main() {
  group('Postfix Notation', () {
    List<_TestCasePrepare> tests = <_TestCasePrepare>[
      _TestCasePrepare(
          '1+1',
          <Token>[
            Token('1'),
            Token("+"),
            Token('1'),
          ],
          {},
          '1.01.0+')
    ];

    run(tests);
  });
}

String string(List<Object> list) {
  StringBuffer sb = StringBuffer();
  list.forEach((e) => sb.write(e));
  return sb.toString();
}
