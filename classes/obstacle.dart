import 'dart:ui' as ui;

import 'package:demo_game/classes/world.dart';

class Obstacle {
  final ui.Color color = ui.Color.fromARGB(255, 100, 100, 100);
  ui.Rect shape;
  final double height = 50;
  final double width = 25;
  double x, y, dx, dy, speed;

  Obstacle(double speed, World world) {
    this.resetPosition(world);
    this.y = world.height - world.groundHeight - this.height;
    this.dx = -1.0;
    this.dy = 0.0;
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

  void handleBounds(World world) {
    if (this.x + this.width <= 0) {
      this.resetPosition(world);
    }
  }

  void resetPosition(World world) {
    this.x = world.width + this.width;
  }
}
