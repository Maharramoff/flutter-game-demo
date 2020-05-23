import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

double devicePixelRatio = ui.window.devicePixelRatio;
ui.Rect ctx = ui.Offset.zero & (ui.window.physicalSize / devicePixelRatio);
ui.Color playerColor = ui.Color.fromARGB(255, 0, 255, 0);
double playerHeight = 100;
double playerWidth = 50;
double groundOffset = 50;
double playerX = 0;
double playerY;
double playerDx = 1;
double playerDy = 0;
double playerSpeed = 5;

int randomInt(int min, int max) {
  var rng = new math.Random();
  return rng.nextInt(max + 1 - min) + min;
}

ui.Picture paint(ui.Rect paintBounds) {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder, ctx);
  updatePlayer();
  drawPlayer(canvas, playerColor);
  return recorder.endRecording();
}

ui.Scene composite(ui.Picture picture, ui.Rect paintBounds) {
  final Float64List deviceTransform = Float64List(16)
    ..[0] = devicePixelRatio
    ..[5] = devicePixelRatio
    ..[10] = 1.0
    ..[15] = 1.0;
  final ui.SceneBuilder sceneBuilder = ui.SceneBuilder()
    ..pushTransform(deviceTransform)
    ..addPicture(ui.Offset.zero, picture)
    ..pop();
  return sceneBuilder.build();
}

ui.Rect createPlayer(x, y, w, h) {
  return ui.Rect.fromLTWH(x, y, w, h);
}

void updatePlayer() {
  handleBounds();
  playerX += playerDx * playerSpeed;
  playerY += playerDy * playerSpeed;
}

void handleBounds() {
  if ((playerX + playerWidth >= ctx.width && playerDx > 0) ||
      (playerX <= 0 && playerDx < 0)) {
    playerDx = -playerDx;
  }
}

void drawPlayer(canvas, color) {
  ui.Rect rect = createPlayer(playerX, playerY, playerWidth, playerHeight);
  canvas.drawRect(rect, ui.Paint()..color = color);
}

void beginFrame(Duration timeStamp) {
  final ui.Picture picture = paint(ctx);
  final ui.Scene scene = composite(picture, ctx);
  ui.window.render(scene);
  ui.window.scheduleFrame();
}

void init() {
  playerY = ctx.height - playerHeight - groundOffset;
}

void main() {
  init();
  ui.window.onBeginFrame = beginFrame;
  ui.window.scheduleFrame();
}
