// levels/level_manager.dart
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../entities/enemy.dart';
import '../entities/boss.dart';
import '../game.dart';

class LevelManager extends Component with HasGameReference<ShooterGame> {
  late int currentLevel;
  late TiledComponent levelMap;
  
  Future<void> loadLevel(int levelNumber) async {
    currentLevel = levelNumber;
    
    // Remove old level if exists
    if (children.any((c) => c is TiledComponent)) {
      removeWhere((c) => c is TiledComponent || c is Enemy || c is Boss);
    }
    
    // Load Tiled map
    final level = await TiledComponent.load('levels/level_$levelNumber.tmx', Vector2.all(16));
    add(level);
    
    // Parse level objects
    await _parseLevelObjects(level);
  }
  
  Future<void> _parseLevelObjects(TiledComponent level) async {
    final objectGroup = level.tileMap.getLayer<ObjectGroup>('objects');
    
    if (objectGroup != null) {
      for (final obj in objectGroup.objects) {
        switch (obj.class_) {
          case 'enemy_spawn':
            _spawnEnemy(obj);
            break;
          case 'boss_spawn':
            if (currentLevel == 2) {
              _spawnBoss(obj);
            }
            break;
          case 'player_start':
            // Set player position
            game.player.position = Vector2(obj.x, obj.y);
            break;
        }
      }
    }
  }
  
  void _spawnEnemy(TiledObject obj) {
    final enemy = Enemy(
      position: Vector2(obj.x, obj.y),
      type: obj.properties.getValue('type') ?? 'minion',
    );
    add(enemy);
  }
  
  void _spawnBoss(TiledObject obj) {
    final boss = Boss(
      position: Vector2(obj.x, obj.y),
    );
    add(boss);
  }
}
