import 'package:flutter/material.dart';

class ExtiroWatermark extends StatelessWidget {
  final Widget child;
  const ExtiroWatermark({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          Positioned(
            left: 0,
            right: 0,
            bottom: 3,
            child: IgnorePointer(
              child: Text(
                'Created By EXTIRO AI',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xB3A0A0A0),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
