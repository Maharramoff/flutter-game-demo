import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

class Helper {
  static int randomInt(int min, int max) {
    var rng = new math.Random();
    return rng.nextInt(max + 1 - min) + min;
  }
}

abstract class Animation {
  void animate(Duration timeStamp);

  ui.Picture paint(ui.Rect rectBounds);

  ui.Scene composite(ui.Picture picture);
}

class Player {
  final ui.Color color = ui.Color.fromARGB(255, 50, 50, 50);
  ui.Rect shape;
  final double height = 100;
  final double width = 50;
  double x, y, dx, dy, speed, gravity, jumpHeight;
  bool grounded;

  Player(x, y, speed) {
    this.x = x;
    this.y = y;
    this.dx = 1.0;
    this.dy = 0.0;
    this.speed = speed;
    this.gravity = 1.0;
    this.grounded = true;
    this.jumpHeight = 6.0;
  }

  void draw(canvas) {
    canvas.drawRect(this.shape, ui.Paint()..color = this.color);
  }

  void update() {
    this.x += this.dx * this.speed;
    this.y += this.dy * this.speed;
    this.shape = ui.Rect.fromLTWH(this.x, this.y, this.width, this.height);
  }

  void handleBounds(World world) {
    if ((this.x + this.width >= world.width && this.dx > 0) ||
        (this.x <= 0 && this.dx < 0)) {
      this.dx = -this.dx;
    }
  }

  void handleGravity(World world)
  {
    // Gravity
    if (this.y + this.height < world.height - world.groundHeight)
    {
      this.dy += this.gravity;
      this.grounded = false;
    }
    else
    {
      this.dy = 0;
      this.y = world.height - world.groundHeight - this.height;
      this.grounded = true;
    }
  }
}

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

class Game implements Animation {
  World world;
  Player player;

  Game() {
    this.world = new World(ui.Color.fromARGB(255, 236, 248, 248),
        ui.Color.fromARGB(255, 178, 150, 125), 50.0);

    this.player = new Player(50.0, 200.0, 2.0);
  }

  void start() {
    ui.window.onBeginFrame = this.animate;
    ui.window.scheduleFrame();
  }

  void animate(Duration timeStamp) {
    final ui.Picture picture = this.paint(this.world.bounds);
    final ui.Scene scene = this.composite(picture);
    ui.window.render(scene);
    ui.window.scheduleFrame();
  }

  void update() {
    this.world.update();
    this.player.handleBounds(this.world);
    this.player.update();
    this.player.handleGravity(this.world);
  }

  void draw(ui.Canvas canvas) {
    this.world.draw(canvas);
    this.player.draw(canvas);
  }

  ui.Picture paint(ui.Rect rectBounds) {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder, rectBounds);
    this.update();
    this.draw(canvas);
    return recorder.endRecording();
  }

  ui.Scene composite(ui.Picture picture) {
    final Float64List deviceTransform = Float64List(16)
      ..[0] = ui.window.devicePixelRatio
      ..[5] = ui.window.devicePixelRatio
      ..[10] = 1.0
      ..[15] = 1.0;
    final ui.SceneBuilder sceneBuilder = ui.SceneBuilder()
      ..pushTransform(deviceTransform)
      ..addPicture(ui.Offset.zero, picture)
      ..pop();
    return sceneBuilder.build();
  }
}

void main() {
  Game game = new Game();
  game.start();
}
