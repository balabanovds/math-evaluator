import 'package:MathEvaluator/math.dart';
import 'package:test/test.dart';
import 'run.dart';

class _TestCase implements Runnable {
  _TestCase(this.name, this.incoming, this.variables, this.want);

  final String name;
  final String incoming;
  final double want;
  final Map<String, double> variables;

  @override
  void run() {
    test('evaluate $name', () {
      final double got = Math(incoming).eval(variables);

      expect(got, equals(want));
    });
  }
}

void main() {
  group('Math', () {
    final List<_TestCase> tests = <_TestCase>[
      _TestCase('10*5+4/2-1', '10*5+4/2-1', <String, double>{}, 51),
      _TestCase('(x*3-5)/5', '(x*3-5)/5', <String, double>{'x': 10}, 5),
      _TestCase('3*x+15/(3+2)', '3*x+15/(3+2)', <String, double>{'x': 10}, 33),
    ];

    run(tests);
  });
}
