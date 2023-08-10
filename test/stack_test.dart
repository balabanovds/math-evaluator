import 'package:MathEvaluator/stack.dart';
import 'package:test/test.dart';
import 'run.dart';

class _TestCaseLastElementsUntil<T> implements Runnable {
  _TestCaseLastElementsUntil(this.name, this.existingStack, this.want, this.f);

  final String name;
  final List<T> existingStack;
  final List<T> want;
  final bool Function(T) f;

  @override
  void run() {
    test('get last elements $name', () {
      final Stack<T> stack = Stack<T>.withValues(existingStack);

      final List<T> got = stack.lastElementsUntil(f);
      expect(got, equals(want));

      // Check that underlying stack did not changed
      expect(stack.stack, equals(existingStack));
    });
  }
}

class _TestCasePushMany<T> implements Runnable {
  _TestCasePushMany(this.name, this.existingStack, this.incoming, this.want);

  final String name;
  final List<T> existingStack;
  final List<T> incoming;
  final List<T> want;

  @override
  void run() {
    test('push many elements $name', () {
      final Stack<T> stack = Stack<T>.withValues(existingStack);

      stack.pushMany(incoming);
      expect(stack.stack, equals(want));
    });
  }
}

class _TestCasePopLastElementsMatch<T> implements Runnable {
  _TestCasePopLastElementsMatch(
      this.name, this.existingStack, this.want, this.f, this.wantStack);

  final String name;
  final List<T> existingStack;
  final List<T> want;
  final List<T> wantStack;
  final bool Function(T) f;

  @override
  void run() {
    test('pop elements that match $name', () {
      final Stack<T> stack = Stack<T>.withValues(existingStack);

      final List<T> got = stack.popLastElementsMatch(f);
      expect(got, equals(want));

      expect(stack.stack, equals(wantStack));
    });
  }
}

class _TestCasePopLastElementsUnless<T> implements Runnable {
  _TestCasePopLastElementsUnless(
      this.name, this.existingStack, this.want, this.wantStack, this.f);

  final String name;
  final List<T> existingStack;
  final List<T> want;
  final List<T> wantStack;
  final bool Function(T) f;

  @override
  void run() {
    test('pop elements unless: $name', () {
      final Stack<T> stack = Stack<T>.withValues(existingStack);

      final List<T> got = stack.popLastElementsUnless(f);
      expect(got, equals(want));

      expect(stack.stack, equals(wantStack));
    });
  }
}

void main() {
  group('Stack', () {
    final List<Runnable> runnables = List<Runnable>.empty(growable: true);

    runnables.addAll(<_TestCaseLastElementsUntil<int>>[
      _TestCaseLastElementsUntil<int>(
          '1,2,3', <int>[3, 4, 5, 3, 2, 1], <int>[1, 2, 3], (int i) => i <= 3),
      _TestCaseLastElementsUntil<int>(
          '1,1,1', <int>[1, 1, 2, 1, 1, 1], <int>[1, 1, 1], (int i) => i <= 1),
    ]);

    runnables.addAll(<_TestCasePushMany<int>>[
      _TestCasePushMany<int>(
          '1,2,3', <int>[5, 5, 5], <int>[1, 2, 3], <int>[5, 5, 5, 1, 2, 3]),
      _TestCasePushMany<int>(
          'add to empty', <int>[], <int>[7, 7, 7], <int>[7, 7, 7])
    ]);

    runnables.addAll(<_TestCasePopLastElementsMatch<int>>[
      _TestCasePopLastElementsMatch<int>('<= 3', <int>[3, 4, 5, 3, 2, 1],
          <int>[1, 2, 3], (int i) => i <= 3, <int>[3, 4, 5]),
      _TestCasePopLastElementsMatch<int>('< 3 pour stack', <int>[1, 2, 2],
          <int>[2, 2, 1], (int i) => i < 3, <int>[]),
    ]);

    runnables.addAll(<_TestCasePopLastElementsUnless<int>>[
      _TestCasePopLastElementsUnless('== 1', <int>[4, 1, 2, 3], <int>[3, 2],
          <int>[4, 1], (int i) => i == 1),
      _TestCasePopLastElementsUnless('== 1 last in stack', <int>[1, 2, 3],
          <int>[3, 2], <int>[1], (int i) => i == 1),
    ]);

    run(runnables);
  });
}
