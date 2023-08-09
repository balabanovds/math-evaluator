class Stack<T> {
  var _stack = List<T>.empty(growable: true);

  Stack();

  Stack.withValues(List<T> list) : this._stack = list;

  List<T> get stack => this._stack;

  // Just take last elements from stack unless func return true.
  // Will not change underlying data.
  List<T> lastElementsUntil(bool Function(T) f) {
    List<T> result = List.empty(growable: true);

    for (var s in this._stack.reversed) {
      if (f(s)) {
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

  push(T value) {
    this._stack.add(value);
  }

  pushMany(List<T> list) {
    this._stack.addAll(list);
  }

  List<T> popLastElementsUntil(bool Function(T) f) {
    List<T> result = List.empty(growable: true);
    List<T> reversed = List.from(this._stack.reversed);

    for (var i = 0; i < this._stack.reversed.length; i++) {
      if (f(reversed[i])) {
        result.add(reversed.removeAt(i));
        continue;
      }
      break;
    }

    return result;
  }
}
