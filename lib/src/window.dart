part of curses_abst;

CursesBinding _binding;

void bindCurses(CursesBinding impl) {
  _binding = impl;
}

abstract class Window {
  Matrix<Cell> _cells;
  Cursor _cursor;
  Function _cellFactory;
  StreamController<ResizeEvent> _resizeEvent;

  Window(int x, int y, Function cellFactory, Cursor cursor) {
    this._cells = new Matrix.supplied(x, y, cellFactory);
    this._cursor = cursor;
    this._cellFactory = cellFactory;
    this._resizeEvent = new StreamController.broadcast();
  }

  factory Window.init() {
    return _binding.initDisplay();
  }

  Cursor get cursor => _cursor;

  int get width => _cells.width;

  int get height => _cells.height;

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

  void resize(int newWidth, int newHeight) {
    _cells.resize(newWidth, newHeight);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (!_cells.exists(x, y))
          _cells.set(x, y, _cellFactory());
      }
    }
  }

  Stream<ResizeEvent> get resizeEvents => _resizeEvent.stream;

  void drawBuffer();
}

abstract class Cell {
  String _text = null;
  TermColour _bg = _binding.defaultBgColour, _fg = _binding.defaultFgColour;
  bool _bold = false, _italic = false, _strikethrough = false, _underline = false;

  set text(String text) => _text = text[0];

  String get text => _text;

  set bg_col(TermColour colour) => _bg = colour;

  TermColour get bg_col => _bg;

  set fg_col(TermColour colour) => _fg = colour;

  TermColour get fg_col => _fg;

  set bold(bool bold) => _bold = bold;

  bool get bold => _bold;

  set italic(bool italic) => _italic = italic;

  bool get italic => _italic;

  set strikethrough(bool strikethrough) => _strikethrough = strikethrough;

  bool get strikethrough => _strikethrough;

  set underline(bool underline) => _underline = underline;

  bool get underline => _underline;

  void clearColour() {
    _bg = _binding.defaultBgColour;
    _fg = _binding.defaultFgColour;
  }

  void clear() {
    text = null;
    clearColour();
  }
}

abstract class Cursor {
  int _x, _y;
  CursorShape _shape;

  int get x => _x;

  set x(int value) => _x = value;

  int get y => _y;

  set y(int value) => _y = value;

  CursorShape get shape => _shape;

  set shape(CursorShape shape) => _shape = shape;

  void clearShape() {
    _shape = _binding.defaultCursorShape;
  }

  void setPosition(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

enum TermColour {
  BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE
}


enum CursorShape {
  BLOCK_FULL, BLOCK_LARGE, BLOCK_HALF, BLOCK_SMALL, UNDERSCORE, BEAM
}

class ResizeEvent {
  final int prevWidth, prevHeight, newWidth, newHeight;

  ResizeEvent(this.prevWidth, this.prevHeight, this.newWidth, this.newHeight);
}