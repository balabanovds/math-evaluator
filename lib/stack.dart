class Stack<T> {
  Stack();
  Stack.withValues(List<T> list) : _stack = list;

  List<T> _stack = List<T>.empty(growable: true);

  List<T> get stack => this._stack;

  int get length => this._stack.length;

  // Just take last elements from stack unless predicate returns true.
  // Will not change underlying data.
  List<T> lastElementsUntil(bool Function(T) predicate) {
    final List<T> result = List<T>.empty(growable: true);

    for (final T s in this._stack.reversed) {
      if (predicate(s)) {
        result.add(s);
        continue;
      }
      break;
    }

    return result;
  }

  T pop() {
    return this._stack.removeLast();
  }

  void push(T value) {
    this._stack.add(value);
  }

  void pushMany(List<T> list) {
    this._stack.addAll(list);
  }

  // Get last elements from stack that match predicate.
  List<T> popLastElementsMatch(bool Function(T) predicate) {
    final List<T> result = List<T>.empty(growable: true);
    final List<T> reversed = List<T>.from(this._stack.reversed);

    for (final T t in reversed) {
      if (predicate(t)) {
        result.add(this._stack.removeLast());
        continue;
      }
      break;
    }

    return result;
  }

  // Get all elements from stack unless meet predicate.
  List<T> popLastElementsUnless(bool Function(T) predicate) {
    final List<T> result = List<T>.empty(growable: true);
    final List<T> reversed = List<T>.from(this._stack.reversed);

    for (final T t in reversed) {
      if (predicate(t)) {
        break;
      }
      result.add(this._stack.removeLast());
    }

    return result;
  }

  List<T> popAll() {
    final List<T> result = List<T>.empty(growable: true);
    final int len = _stack.length;
    int counter = 0;

    while (counter < len) {
      result.add(this._stack.removeLast());
      counter++;
    }

    return result;
  }
}
