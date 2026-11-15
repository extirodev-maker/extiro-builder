import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const Calculator3DApp());
}

class Calculator3DApp extends StatelessWidget {
  const Calculator3DApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _output = '0';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _output = '0';
      } else if (value == '⌫') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
        if (_input.isEmpty) {
          _output = '0';
        }
      } else if (value == '=') {
        _calculateResult();
      } else {
        if (_input == '0' && value != '.') {
          _input = value;
        } else {
          _input += value;
        }
      }
    });
  }

  void _calculateResult() {
    if (_input.isEmpty) return;

    String finalExpression = _input;
    // Replace symbols for evaluation
    finalExpression = finalExpression.replaceAll('×', '*');
    finalExpression = finalExpression.replaceAll('÷', '/');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      // Format output to remove trailing .0 if integer
      if (eval == eval.toInt().toDouble()) {
        _output = eval.toInt().toString();
      } else {
        _output = eval.toString();
      }
    } catch (e) {
      _output = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF232526),
              Color(0xFF414345),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  '3D CALCULATOR',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              // Display Screen
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A24),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(-5, -5),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Color(0x33FFFFFF),
                        offset: Offset(5, 5),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          _input,
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          _output,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Keypad
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      _buildRow(['C', '(', ')', '÷'], [Colors.redAccent, Colors.blueGrey, Colors.blueGrey, Colors.orangeAccent]),
                      const SizedBox(height: 12),
                      _buildRow(['7', '8', '9', '×'], [Colors.white70, Colors.white70, Colors.white70, Colors.orangeAccent]),
                      const SizedBox(height: 12),
                      _buildRow(['4', '5', '6', '-'], [Colors.white70, Colors.white70, Colors.white70, Colors.orangeAccent]),
                      const SizedBox(height: 12),
                      _buildRow(['1', '2', '3', '+'], [Colors.white70, Colors.white70, Colors.white70, Colors.orangeAccent]),
                      const SizedBox(height: 12),
                      _buildRow(['⌫', '0', '.', '='], [Colors.blueGrey, Colors.white70, Colors.white70, Colors.greenAccent]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> labels, List<Color> colors) {
    return Expanded(
      child: Row(
        children: List.generate(labels.length, (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: CalculatorButton(
                label: labels[index],
                textColor: colors[index],
                onPressed: () => _onButtonPressed(labels[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class CalculatorButton extends StatefulWidget {
  final String label;
  final Color textColor;
  final VoidCallback onPressed;

  const CalculatorButton({
    Key? key,
    required this.label,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2B36),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isPressed
              ? const [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(-4, -4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Color(0x22FFFFFF),
                    offset: Offset(4, 4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
