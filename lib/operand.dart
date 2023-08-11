class Operand {
  Operand(this._value, this._isUnary);

  final double _value;
  final bool _isUnary;


  double value() {
    return _isUnary ? 0.0 - _value : _value;
  }

  @override
  String toString() {
    return _isUnary ? '-$_value' : '$_value';
  }
}
