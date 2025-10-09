// entities/enemy.dart
import 'package:flame/components.dart';
import 'package:shooter_v1_ds/game.dart';
import '../projectiles/bullet.dart';

class Enemy extends SpriteAnimationComponent with HasGameReference<ShooterGame> {
  final String type;
  double health = 100;
  double fireCooldown = 0;
  
  Enemy({required super.position, required this.type});
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    size = Vector2.all(32);
    anchor = Anchor.center;
    
    // Load different sprites based on type
    final spritePath = type == 'minion' ? 'enemy_minion.png' : 'enemy_elite.png';
    animation = await game.loadSpriteAnimation(
      spritePath,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.3,
        textureSize: Vector2(32, 32),
      ),
    );
    
    // Set health based on type
    health = type == 'minion' ? 50 : 150;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Simple movement pattern
    position.y += 50 * dt;
    
    // Shooting logic for Level 2
    if (game.currentLevel == 2) {
      fireCooldown -= dt;
      if (fireCooldown <= 0) {
        shoot();
        fireCooldown = 1.5; // 1.5 seconds between shots
      }
    }
    
    // Remove if off screen
    if (position.y > game.size.y + 50) {
      removeFromParent();
    }
  }
  
  void shoot() {
    final bullet = Bullet(
      position: position.clone(),
      direction: Vector2(0, 1), // Shoot downward
      isPlayerBullet: false,
    );
    game.add(bullet);
  }
  
  void takeDamage(double damage) {
    health -= damage;
    if (health <= 0) {
      game.addScore(type == 'minion' ? 100 : 250);
      removeFromParent();
    }
  }
}
