// game.dart
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'levels/level_manager.dart';
import 'entities/player.dart';
import 'ui/hud.dart';

class ShooterGame extends FlameGame with HasKeyboardHandlerComponents {
  late LevelManager levelManager;
  late Player player;
  late HUD hud;
  
  int score = 0;
  int currentLevel = 1;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Initialize level manager
    levelManager = LevelManager();
    add(levelManager);
    
    // Load first level
    await levelManager.loadLevel(1);
    
    // Initialize player
    player = Player();
    add(player);
    
    // Initialize HUD
    hud = HUD();
    add(hud);
    
    // Camera follows player
    camera.follow(player);
  }
  
  void addScore(int points) {
    score += points;
    hud.updateScore(score);
  }
  
  void loadNextLevel() {
    currentLevel++;
    if (currentLevel <= 2) { // Expandable - add more levels
      levelManager.loadLevel(currentLevel);
      player.resetPosition();
    }
  }
  
  void gameOver(bool won) {
    // Handle game over state
    if (won && currentLevel == 1) {
      loadNextLevel();
    }
  }
}
