import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Extiro Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF6366F1),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _expression = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';
  bool _isNewOperand = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _expression = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
        _isNewOperand = false;
      } else if (buttonText == '⌫') {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = '0';
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        _num1 = double.tryParse(_output) ?? 0;
        _operand = buttonText;
        _expression = '$_output $_operand ';
        _isNewOperand = true;
      } else if (buttonText == '%') {
        double val = (double.tryParse(_output) ?? 0) / 100;
        _output = val.toString();
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
        }
      } else if (buttonText == '.') {
        if (_isNewOperand) {
          _output = '0.';
          _isNewOperand = false;
        } else if (!_output.contains('.')) {
          _output = _output + '.';
        }
      } else if (buttonText == '=') {
        _num2 = double.tryParse(_output) ?? 0;
        _expression = '$_expression$_output =';
        
        double result = 0;
        if (_operand == '+') {
          result = _num1 + _num2;
        } else if (_operand == '-') {
          result = _num1 - _num2;
        } else if (_operand == '×') {
          result = _num1 * _num2;
        } else if (_operand == '÷') {
          result = _num2 != 0 ? _num1 / _num2 : 0;
        }

        if (result == result.toInt()) {
          _output = result.toInt().toString();
        } else {
          _output = result.toString();
        }
        _operand = '';
        _isNewOperand = true;
      } else {
        if (_output == '0' || _isNewOperand) {
          _output = buttonText;
          _isNewOperand = false;
        } else {
          _output = _output + buttonText;
        }
      }
    });
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 22),
            backgroundColor: color ?? const Color(0xFF1E293B),
            foregroundColor: textColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 2,
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Extiro Calculator',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _output,
                      style: GoogleFonts.poppins(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF111827),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('C', color: const Color(0xFFEF4444), textColor: Colors.white),
                    _buildButton('⌫', color: const Color(0xFF334155), textColor: Colors.amber),
                    _buildButton('%', color: const Color(0xFF334155), textColor: Colors.amber),
                    _buildButton('÷', color: const Color(0xFF6366F1), textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×', color: const Color(0xFF6366F1), textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', color: const Color(0xFF6366F1), textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', color: const Color(0xFF6366F1), textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('=', color: const Color(0xFF10B981), textColor: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
