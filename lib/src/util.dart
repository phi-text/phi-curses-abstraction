class Matrix<T> {
  List<T> _backing;
  int _width;

  int get width => _width;

  int get height => _backing.length ~/ _width;

  Matrix(int x, int y) {
    this._backing = new List(x * y);
    this._width = x;
  }

  factory Matrix.filled(int x, int y, T value) {
    Matrix matrix = new Matrix(x, y);
    matrix._backing.fillRange(0, matrix._backing.length, value);
    return matrix;
  }

  factory Matrix.supplied(int x, int y, Function factory) {
    Matrix matrix = new Matrix(x, y);
    for (int i = 0; i < matrix._backing.length; i++)
      matrix._backing[i] = factory();
    return matrix;
  }

  T get(int x, int y) => _backing[x + y * _width];

  void set(int x, int y, T value) {
    _backing[x + y * _width] = value;
  }

  bool exists(int x, int y) {
    return get(x, y) != null;
  }

  void resize(int x, int y) {
    List<T> newList = new List(x * y);
    for (int i = 0; i < _backing.length; i++) {
      int xCoord = i % _width, yCoord = (i - x) ~/ _width;
      if (xCoord < x && yCoord < y)
        newList[xCoord + yCoord * x] = _backing[i];
    }
    _backing = newList;
    _width = x;
  }

}