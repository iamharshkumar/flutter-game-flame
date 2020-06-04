import 'dart:ui';

import 'package:fluttergame/game_controller.dart';

class HealthBar {
  final GameController gameController;
  Rect healthBarRect;
  Rect remainingHeathRect;

  HealthBar(this.gameController) {
    double barWidth = gameController.screenSize.width / 1.75;
    healthBarRect = Rect.fromLTWH(
        gameController.screenSize.width / 2 - barWidth / 2,
        gameController.screenSize.height * 0.8,
        barWidth,
        gameController.tileSize * 0.5);

    remainingHeathRect = Rect.fromLTWH(
        gameController.screenSize.width / 2 - barWidth / 2,
        gameController.screenSize.height * 0.8,
        barWidth,
        gameController.tileSize * 0.5);
  }

  void render(Canvas c){
    Paint healthBarColor = Paint()..color = Color(0xFFFF0000);
    Paint remainingBarColor = Paint()..color = Color(0xFF00FF00);
    c.drawRect(healthBarRect, healthBarColor);
    c.drawRect(remainingHeathRect, remainingBarColor);
  }

  void update(double t){
    double barWidth = gameController.screenSize.width / 1.75;
    double percentHealth = gameController.player.currentHealth / gameController.player.maxHealth;
    remainingHeathRect = Rect.fromLTWH(
        gameController.screenSize.width / 2 - barWidth / 2,
        gameController.screenSize.height * 0.8,
        barWidth * percentHealth,
        gameController.tileSize * 0.5);
  }
}
