// projectiles/bullet.dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:shooter_v1_ds/game.dart';
import '../entities/player.dart';
import '../entities/enemy.dart';

class Bullet extends SpriteComponent with HasGameReference<ShooterGame>, CollisionCallbacks {
  final Vector2 direction;
  final bool isPlayerBullet;
  final double speed;
  
  Bullet({
    required super.position,
    required this.direction,
    required this.isPlayerBullet,
    this.speed = 300,
  });
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    size = Vector2(4, 8);
    anchor = Anchor.center;
    
    sprite = await game.loadSprite(
      isPlayerBullet ? 'bullet_player.png' : 'bullet_enemy.png',
    );
    
    // Add hitbox
    add(RectangleHitbox());
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    position += direction * speed * dt;
    
    // Remove if off screen
    if (position.y < -50 || position.y > game.size.y + 50) {
      removeFromParent();
    }
  }
  
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (isPlayerBullet && other is Enemy) {
      other.takeDamage(25);
      removeFromParent();
    } else if (!isPlayerBullet && other is Player) {
      other.takeDamage();
      removeFromParent();
    }
  }
}