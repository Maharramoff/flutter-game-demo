import 'dart:ui' as ui;

class World {
  ui.Color skyColor, groundColor;
  ui.Rect bounds, skyRect, groundRect;
  double height, width, groundHeight;

  World(skyColor, groundColor, groundHeight) {
    this.bounds =
    ui.Offset.zero & (ui.window.physicalSize / ui.window.devicePixelRatio);
    this.skyColor = skyColor;
    this.groundColor = groundColor;
    this.groundHeight = groundHeight;
    this.height = this.bounds.height;
    this.width = this.bounds.width;
  }

  void draw(canvas) {
    this.drawSky(canvas);
    this.drawGround(canvas);
  }

  void drawSky(canvas) {
    canvas.drawRect(this.skyRect, ui.Paint()..color = this.skyColor);
  }

  void drawGround(canvas) {
    canvas.drawRect(this.groundRect, ui.Paint()..color = this.groundColor);
  }

  void update() {
    this.skyRect =
        ui.Rect.fromLTWH(0, 0, this.bounds.width, this.bounds.height);
    this.groundRect = ui.Rect.fromLTWH(
        0,
        this.bounds.height - this.groundHeight + 1,
        this.bounds.width,
        this.bounds.height);
  }
}