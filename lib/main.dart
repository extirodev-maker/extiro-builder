import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

void main() {
  runApp(const RelaxingFuljhadiyaApp());
}

class RelaxingFuljhadiyaApp extends StatelessWidget {
  const RelaxingFuljhadiyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relaxing Fuljhadiya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      home: const FireworksScreen(),
    );
  }
}

class FireworksScreen extends StatefulWidget {
  const FireworksScreen({super.key});

  @override
  State<FireworksScreen> createState() => _FireworksScreenState();
}

class _FireworksScreenState extends State<FireworksScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Firework> _fireworks = [];
  final List<Particle> _particles = [];
  final Random _random = Random();

  bool _isAutoSparks = true;
  double _intensity = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _controller.addListener(_updateSimulation);

    // Initial sparks
    Future.delayed(const Duration(milliseconds: 300), () {
      _launchRandomFirework();
      _launchRandomFirework();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  } 

  void _updateSimulation() {
    setState(() {
      if (_isAutoSparks && _random.nextDouble() < (0.05 * _intensity)) {
        _launchRandomFirework();
      }

      // Update particles
      for (int i = _particles.length - 1; i >= 0; i--) {
        var p = _particles[i];
        p.update();
        if (p.isDead) {
          _particles.removeAt(i);
        }
      }

      // Update fireworks
      for (int i = _fireworks.length - 1; i >= 0; i--) {
        var f = _fireworks[i];
        f.update();
        if (f.isExploded && f.sparks.isEmpty) {
          _fireworks.removeAt(i);
        }
      }
    });
  }

  void _launchRandomFirework() {
    final size = MediaQuery.of(context).size;
    if (size.width == 0 || size.height == 0) return;

    final startX = _random.nextDouble() * size.width;
    final startY = size.height;
    final targetX = 50.0 + _random.nextDouble() * (size.width - 100);
    final targetY = 100.0 + _random.nextDouble() * (size.height * 0.5);

    final color = HSVColor.fromAHSV(1.0, _random.nextDouble() * 360, 0.8, 1.0).toColor();

    setState(() {
      _fireworks.add(Firework(
        startX: startX,
        startY: startY,
        targetX: targetX,
        targetY: targetY,
        color: color,
        onExplode: (x, y, col) {
          _createExplosion(x, y, col);
        },
      ));
    });
  }

  void _createExplosion(double x, double y, Color color) {
    final count = (40 + _random.nextInt(30)).toDouble();
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 1.0 + _random.nextDouble() * 5.0;
      _particles.add(Particle(
        x: x,
        y: y,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        color: color,
        size: 2.0 + _random.nextDouble() * 3.0,
        life: 1.0,
        decay: 0.01 + _random.nextDouble() * 0.02,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050515),
      body: Stack(
        children: [
          // Background ambient gradient for relaxing feel
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [
                    Color(0xFF151030),
                    Color(0xFF050510),
                    Color(0xFF020205),
                  ],
                ),
              ),
            ),
          ),

          // Custom Painter for Fuljhadiya & Fireworks
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) {
                _createExplosion(
                  details.localPosition.dx,
                  details.localPosition.dy,
                  HSVColor.fromAHSV(1.0, _random.nextDouble() * 360, 0.7, 1.0).toColor(),
                );
              },
              child: CustomPaint(
                painter: FireworkPainter(fireworks: _fireworks, particles: _particles),
              ),
            ),
          ),

          // Top Bar with App Title
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✨ Relaxing Fuljhadiya ✨',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Tap anywhere or watch auto sparks',
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      _isAutoSparks ? LucideIcons.volume_2 : LucideIcons.volume_x,
                      color: Colors.amberAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        _isAutoSparks = !_isAutoSparks;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Control Panel
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.white.withOpacity(0.08),
                child: Row(
                  children: [
                    const Icon(LucideIcons.sparkles, color: Colors.amberAccent, size: 20),
                    const SizedBox(width: 12),
                    const Text('Intensity', style: TextStyle(color: Colors.white70)),
                    Expanded(
                      child: Slider(
                        value: _intensity,
                        min: 0.2,
                        max: 2.5,
                        activeColor: Colors.amberAccent,
                        inactiveColor: Colors.white24,
                        onChanged: (val) {
                          setState(() {
                            _intensity = val;
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _launchRandomFirework,
                      child: const Text('Burst'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Firework {
  double startX, startY;
  double targetX, targetY;
  double currentX, currentY;
  Color color;
  bool isExploded = false;
  List<Spark> sparks = [];
  
  final Function(double, double, Color) onExplode;

  Firework({
    required this.startX,
    required this.startY,
    required this.targetX,
    required this.targetY,
    required this.color,
    required this.onExplode,
  })  : currentX = startX,
        currentY = startY;

  void update() {
    if (isExploded) return;

    currentX += (targetX - currentX) * 0.1;
    currentY += (targetY - currentY) * 0.1;

    if ((currentY - targetY).abs() < 5.0) {
      isExploded = true;
      onExplode(targetX, targetY, color);
    }
  }
}

class Spark {
  double x, y;
  Color color;
  Spark({required this.x, required this.y, required this.color});
}

class Particle {
  double x, y;
  double vx, vy;
  Color color;
  double size;
  double life;
  double decay;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.life,
    required this.decay,
  });

  bool get isDead => life <= 0;

  void update() {
    x += vx;
    y += vy;
    vy += 0.08; // gravity
    vx *= 0.96; // friction
    vy *= 0.96;
    life -= decay;
  }
}

class FireworkPainter extends CustomPainter {
  final List<Firework> fireworks;
  final List<Particle> particles;

  FireworkPainter({required this.fireworks, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeCap = StrokeCap.round;

    // Draw launching rockets
    for (var f in fireworks) {
      if (!f.isExploded) {
        paint.color = f.color;
        paint.strokeWidth = 3.0;
        canvas.drawCircle(Offset(f.currentX, f.currentY), 3.0, paint);
        
        // Trail
        paint.color = f.color.withOpacity(0.3);
        canvas.drawLine(
          Offset(f.startX, f.startY),
          Offset(f.currentX, f.currentY),
          paint,
        );
      }
    }

    // Draw explosion particles
    for (var p in particles) {
      paint.color = p.color.withOpacity(p.life.clamp(0.0, 1.0));
      paint.strokeWidth = p.size;
      canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
