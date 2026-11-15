import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const RelaxingFuljhadiyaApp());
}

class RelaxingFuljhadiyaApp extends StatelessWidget {
  const RelaxingFuljhadiyaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relaxing Fuljhadiya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050515),
      ),
      home: const FireworksScreen(),
    );
  }
}

class FireworksScreen extends StatefulWidget {
  const FireworksScreen({Key? key}) : super(key: key);

  @override
  State<FireworksScreen> createState() => _FireworksScreenState();
}

class _FireworksScreenState extends State<FireworksScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Firework> _fireworks = [];
  final Random _random = Random();
  bool _isAmbientSoundOn = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _controller.addListener(_updateFireworks);
    
    // Add initial fireworks
    for (int i = 0; i < 3; i++) {
      _spawnFirework();
    }
  }

  void _spawnFirework() {
    final size = MediaQuery.of(context).size;
    if (size.width == 0) return;
    
    _fireworks.add(
      Firework(
        x: _random.nextDouble() * (size.width - 100) + 50,
        y: _random.nextDouble() * (size.height * 0.6) + 100,
        color: HSLColor.fromAHSL(
          1.0,
          _random.nextDouble() * 360,
          0.8,
          0.7,
        ).toColor(),
      ),
    );
  }

  void _updateFireworks() {
    setState(() {
      for (var f in _fireworks) {
        f.update();
      }
      _fireworks.removeWhere((f) => f.isFinished);

      // Automatically spawn new fuljhadis to keep it magical and relaxing
      if (_random.nextDouble() < 0.08 && _fireworks.length < 8) {
        _spawnFirework();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          // Tap anywhere to burst a new fuljhadi instantly!
          setState(() {
            _fireworks.add(
              Firework(
                x: details.localPosition.dx,
                y: details.localPosition.dy,
                color: HSLColor.fromAHSL(
                  1.0,
                  _random.nextDouble() * 360,
                  0.9,
                  0.6,
                ).toColor(),
              ),
            );
          });
        },
        child: Stack(
          children: [
            // Background gradient for relaxing night feel
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF020208),
                    Color(0xFF0B0B2E),
                    Color(0xFF150A21),
                  ],
                ),
              ),
            },

            // Custom Painter for Glowing Fuljhadiya Sparkles
            CustomPaint(
              size: size,
              painter: FireworkPainter(_fireworks),
            ),

            // Relaxing Title & Instructions
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✨ Relaxing Fuljhadiya ✨',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isAmbientSoundOn
                          = 'Tap anywhere or watch them automatically sparkle',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom controls / info
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.nightlight_round, color: Colors.amberAccent, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Peaceful Glow Mode',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Firework {
  final double x;
  final double y;
  final Color color;
  final List<Particle> particles = [];
  double progress = 0.0;
  bool isFinished = false;

  Firework({required this.x, required this.y, required this.color}) {
    final Random rand = Random();
    // Generate spark particle streams
    for (int i = 0; i < 50; i++) {
      final angle = rand.nextDouble() * 2 * pi;
      final speed = rand.nextDouble() * 4 + 1;
      particles.add(
        Particle(
          angle: angle,
          speed: speed,
          size: rand.nextDouble() * 3 + 1,
        ),
      );
    }
  }

  void update() {
    progress += 0.015;
    if (progress >= 1.0) {
      isFinished = true;
    }
    for (var p in particles) {
      p.update();
    }
  }
}

class Particle {
  double angle;
  double speed;
  double size;
  double currentX = 0;
  double currentY = 0;
  double alpha = 1.0;

  Particle({
    required this.angle,
    required this.speed,
    required this.size,
  });

  void update() {
    currentX += cos(angle) * speed;
    currentY += sin(angle) * speed + 0.3; // slight gravity
    alpha -= 0.02;
    if (alpha < 0) alpha = 0;
  }
}

class FireworkPainter extends CustomPainter {
  final List<Firework> fireworks;

  FireworkPainter(this.fireworks);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (var firework in fireworks) {
      for (var p in firework.particles) {
        final x = firework.x + p.currentX;
        final y = firework.y + p.currentY;

        paint.color = firework.color.withOpacity(p.alpha.clamp(0.0, 1.0));
        canvas.drawCircle(Offset(x, y), p.size, paint);

        // Draw a soft glowing halo around sparkling particles
        final glowPaint = Paint()
          ..color = firework.color.withOpacity((p.alpha * 0.3).clamp(0.0, 1.0))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(x, y), p.size * 1.8, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
