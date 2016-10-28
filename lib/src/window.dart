part of curses_abst;

abstract class Window {
  Matrix<Cell> _cells;

  Window(int width, int height) {
    // TODO Implement
  }

  Window._init(int x, int y, Function cellFactory) {
    _cells = new Matrix.supplied(x, y, cellFactory);
  }

  get width => _cells.width;

  get height => _cells.height;

  Cell getCell(int x, int y) => _cells.get(x, y);

  void write(int x, int y, String text) {
    if (x + text.length > width)
      throw new IndexError(x + text.length, this);
    for (int i = 0; i < text.length; i++)
      getCell(x + i, y).text = text[i];
  }

  void clear() => regionOf(0, 0, width, height).forEach((c) => c.clear());

  Iterable<Cell> regionOf(int x, int y, int width, int height) sync* {
    if (x + width > width)
      throw new IndexError(width, this);
    if (y + height > height)
      throw new IndexError(height, this);
    for (int yOff = 0; yOff < height; yOff++) {
      for (int xOff = 0; xOff < width; xOff++)
        yield getCell(x + xOff, y + yOff);
    }
  }

  void drawBuffer();
}

abstract class Cell {
  String _text;

  set text(String text) => _text = text;

  get text => _text;

  void clearText() {
    text = "";
  }

  void clear() {
    // TODO Implement
  }
}
