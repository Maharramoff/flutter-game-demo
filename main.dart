import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

class Helper {
  static int randomInt(int min, int max) {
    var rng = new math.Random();
    return rng.nextInt(max + 1 - min) + min;
  }
}

class Player {
  final ui.Color color = ui.Color.fromARGB(255, 50, 50, 50);
  ui.Rect worldBounds, shape;
  final double height = 100;
  final double width = 50;
  double x, y, dx, dy, speed;

  Player(worldBounds, x, y, speed) {
    this.worldBounds = worldBounds;
    this.x = x;
    this.y = y;
    this.dx = 1;
    this.dy = 0;
    this.speed = speed;
  }

  void draw(canvas) {
    canvas.drawRect(this.shape, ui.Paint()..color = this.color);
  }

  void update() {
    this.x += this.dx * this.speed;
    this.y += this.dy * this.speed;
    this.shape = ui.Rect.fromLTWH(this.x, this.y, this.width, this.height);
  }

  void handleBounds() {
    if ((this.x + this.width >= this.worldBounds.width && this.dx > 0) ||
        (this.x <= 0 && this.dx < 0)) {
      this.dx = -this.dx;
    }
  }
}

class World {
  ui.Color skyColor, groundColor;
  ui.Rect bounds, skyRect, groundRect;
  double groundHeight;

  World(skyColor, groundColor, groundHeight) {
    this.bounds =
        ui.Offset.zero & (ui.window.physicalSize / ui.window.devicePixelRatio);
    this.skyColor = skyColor;
    this.groundColor = groundColor;
    this.groundHeight = groundHeight;
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

class Game {
  ui.Canvas canvas;
  ui.PictureRecorder recorder;
  ui.Picture picture;
  ui.Scene scene;
  World world;
  Player player;

  Game() {
    this.world = new World(ui.Color.fromARGB(255, 236, 248, 248),
        ui.Color.fromARGB(255, 178, 150, 125), 50.0);

    this.player = new Player(this.world.bounds, 0.0,
        this.world.bounds.height - 100 - this.world.groundHeight, 2.0);
  }

  void start(){
    ui.window.onBeginFrame = this.animate;
    ui.window.scheduleFrame();
  }

  void animate(Duration timeStamp) {
    this.picture = this.paint();
    this.scene = this.composite();
    ui.window.render(this.scene);
    ui.window.scheduleFrame();
  }

  void update() {
    this.world.update();
    this.player.handleBounds();
    this.player.update();
  }

  void draw() {
    this.world.draw(this.canvas);
    this.player.draw(this.canvas);
  }

  ui.Picture paint() {
    this.recorder = ui.PictureRecorder();
    this.canvas = ui.Canvas(recorder, this.world.bounds);
    this.update();
    this.draw();
    return recorder.endRecording();
  }

  ui.Scene composite() {
    final Float64List deviceTransform = Float64List(16)
      ..[0] = ui.window.devicePixelRatio
      ..[5] = ui.window.devicePixelRatio
      ..[10] = 1.0
      ..[15] = 1.0;
    final ui.SceneBuilder sceneBuilder = ui.SceneBuilder()
      ..pushTransform(deviceTransform)
      ..addPicture(ui.Offset.zero, this.picture)
      ..pop();
    return sceneBuilder.build();
  }
}

void main() {
  Game game = new Game();
  game.start();
}
