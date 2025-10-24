// entities/player.dart
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game.dart';
import '../projectiles/bullet.dart';

class Player extends SpriteAnimationComponent 
    with HasGameReference<ShooterGame>, KeyboardHandler {
  
  static const double speed = 200;
  static const double fireRate = 0.2; // seconds between shots
  double fireCooldown = 0;
  
  final Vector2 velocity = Vector2.zero();
  
  Player() : super(size: Vector2.all(32), anchor: Anchor.center);
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load player sprite
    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(32, 32),
      ),
    );
    
    position = Vector2(100, 100);
  }
  
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Keep player in bounds
    position = Vector2(
      position.x.clamp(0, size.x),
      position.y.clamp(0, size.y),
    );
  }
  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    velocity.setZero();
    
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      velocity.y = -1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      velocity.y = 1;
    }
    
    // Normalize diagonal movement
    if (velocity.length > 0) {
      velocity.normalize();
      velocity.scale(speed);
    }
    
    // Shooting
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      shoot();
    }
    
    return true;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update position
    position += velocity * dt;
    
    // Update fire cooldown
    if (fireCooldown > 0) {
      fireCooldown -= dt;
    }
  }
  
  void shoot() {
    if (fireCooldown <= 0) {
      final bullet = Bullet(
        position: position.clone(),
        direction: Vector2(0, -1), // Shoot upward
        isPlayerBullet: true,
      );
      game.add(bullet);
      fireCooldown = fireRate;
    }
  }
  
  void takeDamage() {
    // Handle player damage
    add(ColorEffect(
      Colors.red,
      EffectController(duration: 0.2),
    ));
  }
  
  void resetPosition() {
    position = Vector2(game.size.x / 2, game.size.y - 100);
  }
}
