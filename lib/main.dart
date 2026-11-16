import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

void main() => runApp(const TapMagicApp());

class TapMagicApp extends StatelessWidget {
  const TapMagicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap Magic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
      ),
      home: const TapMagicHomePage(),
    );
  }
}

class TapAnimationItem {
  final Offset position;
  final int type;
  final Color color;
  TapAnimationItem({required this.position, required this.type, required this.color});
}

class TapMagicHomePage extends StatefulWidget {
  const TapMagicHomePage({super.key});

  @override
  State<TapMagicHomePage> createState() => _TapMagicHomePageState();
}

class _TapMagicHomePageState extends State<TapMagicHomePage> with TickerProviderStateMixin {
  final List<TapAnimationItem> _taps = [];
  final Random _random = Random();
  late ConfettiController _confettiController;
  int _tapCount = 0;
  String _currentEffectName = 'Tap Anywhere!';

  final List<String> _effectNames = [
    'Ripple Wave',
    'Star Burst',
    'Floating Hearts',
    'Color Explosion',
    'Confetti Blast'
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    final position = details.localPosition;
    final type = _random.nextInt(5);
    final color = Color.fromRGBO(
      _random.nextInt(200) + 55,
      _random.nextInt(200) + 55,
      _random.nextInt(200) + 55,
      1,
    );

    setState(() {
      _tapCount++;
      _currentEffectName = _effectNames[type];
      _taps.add(TapAnimationItem(position: position, type: type, color: color));
      if (_taps.length > 15) {
        _taps.removeAt(0);
      }
    });

    if (type == 4) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTap,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF311042)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                gravity: 0.2,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '✨ Tap Magic',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Text(
                            'Taps: $_tapCount',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app, size: 60, color: Colors.white.withOpacity(0.6)),
                          const SizedBox(height: 16),
                          Text(
                            _currentEffectName,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pinkAccent.shade100),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Screen par kahi bhi tap karein aur magic dekhein!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            ..._taps.map((item) => Positioned(
                  left: item.position.dx - 50,
                  top: item.position.dy - 50,
                  child: IgnorePointer(
                    child: CustomAnimationWidget(type: item.type, color: item.color),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class CustomAnimationWidget extends StatefulWidget {
  final int type;
  final Color color;
  const CustomAnimationWidget({super.key, required this.type, required this.color});

  @override
  State<CustomAnimationWidget> createState() => _CustomAnimationWidgetState();
}

class _CustomAnimationWidgetState extends State<CustomAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Center(child: _buildEffectContent()),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEffectContent() {
    switch (widget.type) {
      case 0:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: widget.color, width: 3),
          ),
        );
      case 1:
        return Icon(Icons.star, color: widget.color, size: 50);
      case 2:
        return Icon(Icons.favorite, color: widget.color, size: 45);
      case 3:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(0.4),
            boxShadow: [
              BoxShadow(color: widget.color, blurRadius: 15, spreadRadius: 5),
            ],
          ),
        );
      case 4:
      default:
        return Icon(Icons.bolt, color: widget.color, size: 50);
    }
  }
}
