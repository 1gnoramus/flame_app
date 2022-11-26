import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

void main() {
  print('sad');
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}

class MyGame extends FlameGame {
  SpriteComponent queen = SpriteComponent();
  SpriteComponent knight = SpriteComponent();
  SpriteComponent background = SpriteComponent();

  final double characterSize = (200);
  @override
  Future<void> onLoad() async {
    super.onLoad();
    print('object');

    final screenWidth = size[0];
    final screenHeight = size[1];
    final textBoxHeight = 100;
    add(background
      ..sprite = await loadSprite('background_1.jpg')
      ..size = size);
    queen
      ..sprite = await loadSprite('queen.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight;

    add(queen);
    knight
      ..sprite = await loadSprite('knight.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..x = screenWidth - characterSize;
    add(knight);
  }

  @override
  void update(double dt) {
    super.update(dt);
    queen.x += 30 * dt;
    knight.x -= 30 * dt;
  }
}
