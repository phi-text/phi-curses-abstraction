part of curses_abst;

abstract class Window {
  Matrix<Cell> _cells;

  Window(int x, int y) {
    _cells = new Matrix.supplied(x, y, () => new Cell());
  }

  Cell getCell(int x, int y) => _cells.get(x, y);

  void drawBuffer();
}

abstract class Cell {
  Cell();
}
