import 'dart:ui' as ui;

import 'package:demo_game/classes/world.dart';

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

  void handleGravity(World world) {
    // Gravity
    if (this.y + this.height < world.height - world.groundHeight) {
      this.dy += this.gravity;
      this.grounded = false;
    } else {
      this.dy = 0;
      this.y = world.height - world.groundHeight - this.height;
      this.grounded = true;
    }
  }

  void jump({double height = 0}) {
    if (this.grounded) {
      this.dy = -(height > 0 ? height : this.jumpHeight);
      this.grounded = false;
    }
  }
}
