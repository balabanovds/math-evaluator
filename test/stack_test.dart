import 'package:MathEvaluator/stack.dart';
import 'package:test/test.dart';

class _TestCaseLastElementsUntil<T> {
  final String name;
  final List<T> existingStack;
  final List<T> want;
  final bool Function(T) f;

  _TestCaseLastElementsUntil(this.name, this.existingStack, this.want, this.f);

  run() {
    test('get last elements $name', () {
      Stack<T> stack = Stack.withValues(existingStack);

      List<T> got = stack.lastElementsUntil(f);
      expect(got, equals(want));

      // Check that underlying stack did not changed
      expect(stack.stack, equals(existingStack));
    });
  }
}

class _TestCasePushMany<T> {
  final String name;
  final List<T> existingStack;
  final List<T> incoming;
  final List<T> want;

  _TestCasePushMany(this.name, this.existingStack, this.incoming, this.want);

  run() {
    test('push many elements $name', () {
      Stack<T> stack = Stack.withValues(existingStack);

      stack.pushMany(incoming);
      expect(stack.stack, equals(want));
    });
  }
}

class _TestCasePopLastElementsUntil<T> {
  final String name;
  final List<T> existingStack;
  final List<T> want;
  final List<T> wantStack;
  final bool Function(T) f;

  _TestCasePopLastElementsUntil(
      this.name, this.existingStack, this.want, this.f, this.wantStack);

  run() {
    test('pop many elements $name', () {
      Stack<T> stack = Stack.withValues(existingStack);

      var got = stack.popLastElementsUntil(f);
      expect(got, equals(want));

      expect(stack.stack, equals(wantStack));
    });
  }
}

void main() {
  group('Stack', () {
    [
      _TestCaseLastElementsUntil(
          "1,2,3", [3, 4, 5, 3, 2, 1], [1, 2, 3], (i) => i <= 3),
      _TestCaseLastElementsUntil(
          "1,1,1", [1, 1, 2, 1, 1, 1], [1, 1, 1], (i) => i <= 1),
    ].forEach((test) => test.run());

    [
      _TestCasePushMany('1,2,3', [5, 5, 5], [1, 2, 3], [5, 5, 5, 1, 2, 3]),
      _TestCasePushMany('add to empty', [], [7, 7, 7], [7, 7, 7])
    ].forEach((test) => test.run());

    [
      _TestCasePopLastElementsUntil(
          '1,2,3', [3, 4, 5, 3, 2, 1], [1, 2, 3], (i) => i <= 3, [3, 4, 5]),
      _TestCasePopLastElementsUntil(
          'pour stack', [1, 2, 2], [1, 2, 2], (i) => i < 3, []),
    ].forEach((test) => test.run());
  });
}
