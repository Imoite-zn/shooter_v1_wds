// ui/hud.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../game.dart';

class HUD extends PositionComponent with HasGameReference<ShooterGame> {
  late TextPaint scoreTextPaint;
  late TextPaint timerTextPaint;
  late TextPaint levelTextPaint;
  
  double levelTime = 0;
  bool isLevelActive = true;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    scoreTextPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontFamily: 'Arial',
      ),
    );
    
    timerTextPaint = TextPaint(
      style: const TextStyle(
        color: Colors.yellow,
        fontSize: 24,
        fontFamily: 'Arial',
      ),
    );
    
    levelTextPaint = TextPaint(
      style: const TextStyle(
        color: Colors.cyan,
        fontSize: 20,
        fontFamily: 'Arial',
      ),
    );
    
    // HUD is always on top
    priority = 100;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    if (isLevelActive) {
      levelTime += dt;
    }
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final scoreText = 'Score: ${game.score}';
    final timerText = 'Time: ${levelTime.toStringAsFixed(1)}s';
    final levelText = 'Level: ${game.currentLevel}';
    
    // Render tutorial text for level 1
    if (game.currentLevel == 1) {
      final tutorialText = 'Move: Arrow Keys | Shoot: Space';
      scoreTextPaint.render(
        canvas,
        tutorialText,
        Vector2(20, game.size.y - 60),
      );
    }
    
    scoreTextPaint.render(canvas, scoreText, Vector2(20, 20));
    timerTextPaint.render(canvas, timerText, Vector2(20, 50));
    levelTextPaint.render(canvas, levelText, Vector2(20, 80));
  }
  
  void updateScore(int newScore) {
    // Score updates automatically through gameRef
  }
  
  void levelComplete() {
    isLevelActive = false;
  }
}