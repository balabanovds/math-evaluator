import 'package:MathEvaluator/postfix_notation.dart';
import 'package:MathEvaluator/token.dart';
import 'package:test/test.dart';
import 'run.dart';

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
    final List<_TestCasePrepare> tests = <_TestCasePrepare>[
      _TestCasePrepare(
        '1+1',
        <Token>[
          Token('1'),
          Token('+'),
          Token('1'),
        ],
        <String, double>{},
        '1.01.0+',
      ),
      _TestCasePrepare(
        '5-(-10+7*3)',
        <Token>[
          Token('5'),
          Token('-'),
          Token('('),
          Token('-'),
          Token('10'),
          Token('+'),
          Token('7'),
          Token('*'),
          Token('3'),
          Token(')'),
        ],
        <String, double>{},
        '5.0-10.07.03.0*+-',
      ),
      _TestCasePrepare(
        '(x+3-5)/5',
        <Token>[
          Token('('),
          Token('x'),
          Token('*'),
          Token('3'),
          Token('-'),
          Token('5'),
          Token(')'),
          Token('/'),
          Token('5'),
        ],
        <String, double>{'x': 10},
        '10.03.0*5.0-5.0/',
      ),
      _TestCasePrepare(
        '10*5+4/2-1',
        <Token>[
          Token('10'),
          Token('*'),
          Token('5'),
          Token('+'),
          Token('4'),
          Token('/'),
          Token('2'),
          Token('-'),
          Token('1'),
        ],
        <String, double>{},
        '10.05.0*4.02.0/+1.0-',
      ),
      _TestCasePrepare(
        '3*x+15/(3+2)',
        <Token>[
          Token('3'),
          Token('*'),
          Token('x'),
          Token('+'),
          Token('15'),
          Token('/'),
          Token('('),
          Token('3'),
          Token('+'),
          Token('2'),
          Token(')'),
        ],
        <String, double>{
          'x': 10,
        },
        '3.010.0*15.03.02.0+/+',
      ),
    ];

    run(tests);
  });
}

String string(List<Object> list) {
  final StringBuffer sb = StringBuffer();
  list.forEach((Object e) => sb.write(e));
  return sb.toString();
}
