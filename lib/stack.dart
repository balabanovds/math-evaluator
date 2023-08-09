class Stack<T> {
  Stack();
  Stack.withValues(List<T> list) : _stack = list;
  
  List<T> _stack = List<T>.empty(growable: true);



  List<T> get stack => this._stack;

  // Just take last elements from stack unless func return true.
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

  List<T> popLastElementsUntil(bool Function(T) predicate) {
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
}
