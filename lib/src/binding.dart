part of curses_abst;

abstract class CursesBinding {
  Window initDisplay();

  TermColour get defaultBgColour;

  TermColour get defaultFgColour;

  CursorShape get defaultCursorShape;
}