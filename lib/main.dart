import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}

class MyGame extends FlameGame with HasTappables {
  SpriteComponent queen = SpriteComponent();
  SpriteComponent knight = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  SpriteComponent background_2 = SpriteComponent();

  DialogButton dialogButton = DialogButton();
  Vector2 buttonSize = Vector2(50.0, 50.0);

  final double characterSize = (200);
  bool turnAway = false;
  int dialogLevel = 0;
  int sceneLevel = 1;

  TextPaint dialogTextPaint = TextPaint(style: const TextStyle(fontSize: 30));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final screenWidth = size[0];
    final screenHeight = size[1];
    final textBoxHeight = 100;

    background_2
      ..sprite = await loadSprite('bg_2.jpg')
      ..size = Vector2(size[0], size[1] - textBoxHeight);

    add(
      background
        ..sprite = await loadSprite('background_1.jpg')
        ..size = Vector2(size[0], size[1] - textBoxHeight),
    );
    queen
      ..sprite = await loadSprite('queen.png')
      ..size = Vector2(characterSize, characterSize)
      ..anchor = Anchor.topCenter
      ..y = screenHeight - characterSize - textBoxHeight;

    add(queen);
    knight
      ..sprite = await loadSprite('knight.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..x = screenWidth
      ..anchor = Anchor.topCenter
      ..flipHorizontally();
    add(knight);

    dialogButton
      ..sprite = await loadSprite('next_button.png')
      ..size = buttonSize
      ..position =
          Vector2(size[0] - buttonSize[0] - 10, size[1] - buttonSize[1] - 10);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (queen.x < size[0] / 2 - 100) {
      queen.x += 30 * dt;
      if (queen.x > 50 && dialogLevel == 0) {
        dialogLevel++;
      }
      if (queen.x > 150 && dialogLevel == 1) {
        dialogLevel++;
      }
    } else if (turnAway == false && sceneLevel == 1) {
      knight.flipHorizontally();
      turnAway = true;
      if (dialogLevel == 2) {
        dialogLevel++;
      }
    }
    if (knight.x > size[0] / 2 - 50 && sceneLevel == 1) {
      knight.x -= 60 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    switch (dialogLevel) {
      case 1:
        dialogTextPaint.render(
            canvas, 'NOCHEAS: Hey! How are you?', Vector2(10, size[1] - 100));
        break;
      case 2:
        dialogTextPaint.render(canvas, 'MENOS: Yo. Couldn\'t be better. You?',
            Vector2(10, size[1] - 100));
        add(dialogButton);
        break;
      case 3:
        dialogTextPaint.render(
            canvas, 'NOCHEAS: Wo ye hao!', Vector2(10, size[1] - 100));
        break;
    }
    switch (dialogButton.scene2Level) {
      case 1:
        sceneLevel = 2;
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dialogTextPaint.render(canvas, 'MENOS: Learning chinese, aye?',
            Vector2(10, size[1] - 100));
        if (turnAway) {
          knight.flipHorizontally();
          knight.x = knight.x + 150;
          turnAway = false;

          add(background_2);
          queen.changeParent(background_2);
          knight.changeParent(background_2);
        }
        break;
      case 2:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dialogTextPaint.render(canvas, 'NOCHEAS: Yeap. How could i forget?',
            Vector2(10, size[1] - 100));
        break;
      case 3:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dialogTextPaint.render(canvas, 'MENOS: Translate this then: \'我爱您\'',
            Vector2(10, size[1] - 100));
        break;
    }
  }
}

class DialogButton extends SpriteComponent with Tappable {
  int scene2Level = 0;
  @override
  bool onTapDown(TapDownInfo event) {
    try {
      print('next screen');
      scene2Level += 1;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
