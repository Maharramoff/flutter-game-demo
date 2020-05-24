import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:demo_game/classes/obstacle.dart';
import 'package:demo_game/classes/player.dart';
import 'package:demo_game/classes/world.dart';
import 'package:demo_game/interfaces/animation_frame.dart';

class Game implements AnimationFrame {
  World world;
  Player player;
  Obstacle obstacle;
  bool running, over;

  Game() {
    this.world = new World(ui.Color.fromARGB(255, 236, 248, 248),
        ui.Color.fromARGB(255, 178, 150, 125), 50.0);

    this.player = new Player.withDx(50.0, 200.0, 0.0);
    this.obstacle = new Obstacle(4.0, this.world);
    this.running = true;
    this.over = false;
  }

  void start() {
    ui.window.onBeginFrame = this.animate;
    ui.window.onPointerDataPacket = this.handlePointer;
    ui.window.scheduleFrame();
  }

  void animate(Duration timeStamp) {
    if (this.running) {
      final ui.Picture picture = this.paint(this.world.bounds);
      final ui.Scene scene = this.composite(picture);
      ui.window.render(scene);
      ui.window.scheduleFrame();
    }
  }

  void update() {
    this.world.update();
    this.player.handleBounds(this.world);
    this.player.update();
    this.player.handleGravity(this.world);
    this.obstacle.handleBounds(this.world);
    this.obstacle.update();
  }

  void draw(ui.Canvas canvas) {
    this.world.draw(canvas);
    this.player.draw(canvas);
    this.obstacle.draw(canvas);
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

  void handlePointer(ui.PointerDataPacket packet) {
    for (ui.PointerData pointer in packet.data) {
      if (pointer.change == ui.PointerChange.down) {
        this.player.jump(height: 20);
        ui.window.scheduleFrame();
      }
    }
  }
}
