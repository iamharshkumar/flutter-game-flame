import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttergame/components/healthBar.dart';
import 'package:fluttergame/components/highscore_text.dart';
import 'package:fluttergame/components/score_text.dart';
import 'package:fluttergame/components/start_button.dart';
import 'package:fluttergame/enemySpawner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttergame/state.dart';

import 'components/enemy.dart';
import 'components/player.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Random rand;
  Size screenSize;
  double tileSize;
  Player player;
  EnemySpawner enemySpawner;
  List<Enemy> enemies;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  States state;
  HighscoreText highscoreText;
  StartButton startButton;

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    rand = Random();
    resize(await Flame.util.initialDimensions());
    state = States.menu;
    player = Player(this);
    enemies = List<Enemy>();
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    startButton = StartButton(this);
  }

  @override
  void render(Canvas c) async {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);

    Paint backgroundPaint = Paint()
      ..color = Color(0xFFFAFAFA);
    c.drawRect(background, backgroundPaint);

    player.render(c);

    if (state == States.menu) {
      startButton.render(c);
      highscoreText.render(c);

    } else if (state == States.playing) {
      enemies.forEach((Enemy enemy) => enemy.render(c));
      scoreText.render(c);
      healthBar.render(c);
    }
  }

  @override
  void update(double t) {
    if (state == States.menu) {
      startButton.update(t);
      highscoreText.update(t);
    } else if(state == States.playing) {
    enemySpawner.update (t);
    enemies.forEach((Enemy enemy) => enemy.update(t));
    enemies.removeWhere((Enemy enemy) => enemy.isDead);
    player.update(t);
    scoreText.update(t);
    healthBar.update(t);
  }

    }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if(state == States.menu){
      state = States.playing;
    } else if (state == States.playing){
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
      //Top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
      //Right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
      //Bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
      //Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}
