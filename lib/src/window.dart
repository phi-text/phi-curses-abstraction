part of curses_abst;

abstract class Window {
  Matrix<Cell> _cells;

  Window(int x, int y) {
    _cells = new Matrix.supplied(x, y, () => new Cell());
  }

  Cell getCell(int x, int y) => _cells.get(x, y);

  void write(int x, int y, String text) {
    if (x + text.length > _cells.width)
      throw new IndexError(x + text.length, this);
    for (int i = 0; i < text.length; i++)
      getCell(x + i, y).text = text[i];
  }

  Iterable<Cell> regionOf(int x, int y, int width, int height) sync* {
    if (x + width > _cells.width)
      throw new IndexError(width, this);
    if (y + height > _cells.height)
      throw new IndexError(height, this);
    for (int yOff = 0; yOff < height; yOff++) {
      for (int xOff = 0; xOff < width; xOff++)
        yield _cells.get(x + xOff, y + yOff);
    }
  }

  void drawBuffer();
}

abstract class Cell {
  String _text;

  set text(String text) => _text = text;

  get text => _text;

  void clear() {
    text = "";
  }
}
