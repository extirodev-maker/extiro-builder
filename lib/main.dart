import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Extiro Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
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
  String _output = '0';
  String _currentNumber = '';
  String _operand = '';
  double _num1 = 0;
  double _num2 = 0;
  bool _isFinished = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _output = '0';
        _currentNumber = '';
        _operand = '';
        _num1 = 0;
        _num2 = 0;
        _isFinished = false;
      } else if (buttonText == '⌫') {
        if (_currentNumber.isNotEmpty) {
          _currentNumber = _currentNumber.substring(0, _currentNumber.length - 1);
          _output = _currentNumber.isEmpty ? '0' : _currentNumber;
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        if (_currentNumber.isNotEmpty) {
          _num1 = double.parse(_currentNumber);
          _operand = buttonText;
          _currentNumber = '';
        } else if (_output != '0') {
          _num1 = double.parse(_output);
          _operand = buttonText;
        }
      } else if (buttonText == '.') {
        if (!_currentNumber.contains('.')) {
          _currentNumber += '.';
          _output = _currentNumber;
        }
      } else if (buttonText == '=') {
        if (_operand.isNotEmpty && _currentNumber.isNotEmpty) {
          _num2 = double.parse(_currentNumber);
          if (_operand == '+') {
            _output = (_num1 + _num2).toString();
          } else if (_operand == '-') {
            _output = (_num1 - _num2).toString();
          } else if (_operand == '×') {
            _output = (_num1 * _num2).toString();
          } else if (_operand == '÷') {
            _output = _num2 == 0 ? 'Error' : (_num1 / _num2).toString();
          }
          // Clean up trailing .0
          if (_output.endsWith('.0')) {
            _output = _output.substring(0, _output.length - 2);
          }
          _currentNumber = _output;
          _operand = '';
          _isFinished = true;
        }
      } else {
        if (_isFinished) {
          _currentNumber = '';
          _isFinished = false;
        }
        _currentNumber += buttonText;
        _output = _currentNumber;
      }
    });
  }

  Widget _buildButton(String text, {Color? textColor, Color? bgColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor ?? const Color(0xFF1E1E1E),
            foregroundColor: textColor ?? Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w500,
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Extiro Calculator',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey[400],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Text(
                    _output,
                    style: GoogleFonts.poppins(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            const Divider(color: Color(0xFF2C2C2C), height: 1),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildButton('AC', textColor: const Color(0xFFFF6B6B), bgColor: const Color(0xFF2C1E1E)),
                        _buildButton('⌫', textColor: const Color(0xFFFFB703), bgColor: const Color(0xFF2C2516)),
                        _buildButton('%', textColor: const Color(0xFF4CC9F0), bgColor: const Color(0xFF16232C)),
                        _buildButton('÷', textColor: const Color(0xFF4CC9F0), bgColor: const Color(0xFF16232C)),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton('×', textColor: const Color(0xFF4CC9F0), bgColor: const Color(0xFF16232C)),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton('-', textColor: const Color(0xFF4CC9F0), bgColor: const Color(0xFF16232C)),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton('+', textColor: const Color(0xFF4CC9F0), bgColor: const Color(0xFF16232C)),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('0'),
                        _buildButton('.'),
                        _buildButton('=', textColor: Colors.white, bgColor: const Color(0xFF4361EE)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
