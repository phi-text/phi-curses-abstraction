part of curses_abst;

abstract class CursesBinding {
  Window initDisplay(int width, int height);

  TermColour get defaultBgColour;

  TermColour get defaultFgColour;

  CursorShape get defaultCursorShape;
}