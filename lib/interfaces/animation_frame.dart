import 'dart:ui' as ui;

abstract class AnimationFrame {
  void animate(Duration timeStamp);

  ui.Picture paint(ui.Rect rectBounds);

  ui.Scene composite(ui.Picture picture);
}