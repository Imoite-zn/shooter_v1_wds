
// entities/boss.dart
import 'package:flame/components.dart';
import 'package:shooter_v1_ds/game.dart';
import '../projectiles/bullet.dart';

class Boss extends SpriteAnimationComponent with HasGameReference<ShooterGame> {
  double health = 1000;
  double fireCooldown = 0;
  int phase = 1;
  
  Boss({required super.position});
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    size = Vector2.all(64);
    anchor = Anchor.center;
    
    animation = await game.loadSpriteAnimation(
      'boss.png',
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: 0.2,
        textureSize: Vector2(64, 64),
      ),
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Boss movement pattern
    position.x += 100 * dt * (position.x < game.size.x / 2 ? 1 : -1);
    
    // Boss shooting patterns
    fireCooldown -= dt;
    if (fireCooldown <= 0) {
      if (phase == 1) {
        shootPhase1();
      } else {
        shootPhase2();
      }
      fireCooldown = phase == 1 ? 1.0 : 0.5;
    }
    
    // Phase transition
    if (health <= 500 && phase == 1) {
      phase = 2;
      // Add phase transition effects
    }
  }
  
  void shootPhase1() {
    // Single shot
    final bullet = Bullet(
      position: position.clone(),
      direction: Vector2(0, 1),
      isPlayerBullet: false,
      speed: 150,
    );
    game.add(bullet);
  }
  
  void shootPhase2() {
    // Spread shot
    for (int i = -2; i <= 2; i++) {
      final bullet = Bullet(
        position: position.clone(),
        direction: Vector2(i * 0.2, 1).normalized(),
        isPlayerBullet: false,
        speed: 120,
      );
      game.add(bullet);
    }
  }
  
  void takeDamage(double damage) {
    health -= damage;
    if (health <= 0) {
      game.addScore(1000);
      game.gameOver(true);
      removeFromParent();
    }
  }
}