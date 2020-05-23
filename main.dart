import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

double devicePixelRatio = ui.window.devicePixelRatio;
ui.Rect ctx = ui.Offset.zero & (ui.window.physicalSize / devicePixelRatio);
ui.Color color;
double objHeight = 100;
double objWidth = 50;
double groundOffset = 50;
double x = 100;
double y = ctx.height - objHeight - groundOffset;

int randomInt(int min, int max) {
  var rng = new math.Random();
  return rng.nextInt(max + 1 - min) + min;
}

void beginFrame(Duration timeStamp) {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder, ctx);

  canvas.drawRect(ui.Rect.fromLTWH(x, y, objWidth, objHeight),
      ui.Paint()..color = color);
  final ui.Picture picture = recorder.endRecording();
  final Float64List deviceTransform = Float64List(16)
    ..[0] = devicePixelRatio
    ..[5] = devicePixelRatio
    ..[10] = 1.0
    ..[15] = 1.0;
  final ui.SceneBuilder sceneBuilder = ui.SceneBuilder()
    ..pushTransform(deviceTransform)
    ..addPicture(ui.Offset.zero, picture)
    ..pop();
  ui.window.render(sceneBuilder.build());
  ui.window.scheduleFrame();
}

void main() {
  color = ui.Color.fromARGB(255, 0, 255, 0);
  ui.window.onBeginFrame = beginFrame;
  ui.window.scheduleFrame();
}
