import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primarySwatch: Colors.deepOrange,
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
  String _currentExpression = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';
  bool _isNewOperand = true;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _currentExpression = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
        _isNewOperand = true;
      } else if (buttonText == '⌫') {
        if (_output.isNotEmpty && _output != '0') {
          _output = _output.substring(0, _output.length - 1);
          if (_output.isEmpty || _output == '-') {
            _output = '0';
            _isNewOperand = true;
          }
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        _num1 = double.tryParse(_output) ?? 0;
        _operand = buttonText;
        _currentExpression = '$_num1 $_operand ';
        _isNewOperand = true;
      } else if (buttonText == '.') {
        if (_isNewOperand) {
          _output = '0.';
          _isNewOperand = false;
        } else if (!_output.contains('.')) {
          _output = '$_output.';
        }
      } else if (buttonText == '%') {
        double val = double.tryParse(_output) ?? 0;
        val = val / 100;
        _output = val.toString();
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
        }
      } else if (buttonText == '=') {
        _num2 = double.tryParse(_output) ?? 0;
        double result = 0;

        if (_operand == '+') {
          result = _num1 + _num2;
        } else if (_operand == '-') {
          result = _num1 - _num2;
        } else if (_operand == '×') {
          result = _num1 * _num2;
        } else if (_operand == '÷') {
          if (_num2 == 0) {
            _output = 'Error';
            _currentExpression = '';
            _isNewOperand = true;
            return;
          } else {
            result = _num1 / _num2;
          }
        }

        String resStr = result.toString();
        if (resStr.endsWith('.0')) {
          resStr = resStr.substring(0, resStr.length - 2);
        }
        _currentExpression = '$_num1 $_operand $_num2 =';
        _output = resStr;
        _isNewOperand = true;
      } else {
        // Numbers
        if (_isNewOperand) {
          _output = buttonText;
          _isNewOperand = false;
        } else {
          if (_output == '0') {
            _output = buttonText;
          } else {
            _output += buttonText;
          }
        }
      }
    });
  }

  Widget _buildButton(String text, {Color? textColor, Color? bgColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 22),
            backgroundColor: bgColor ?? const Color(0xFF1E1E1E),
            foregroundColor: textColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extiro Calculator', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _currentExpression,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _output,
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Keypad Area
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF181818),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('C', textColor: Colors.redAccent, bgColor: const Color(0xFF2C2C2C)),
                    _buildButton('⌫', textColor: Colors.orangeAccent, bgColor: const Color(0xFF2C2C2C)),
                    _buildButton('%', textColor: Colors.orangeAccent, bgColor: const Color(0xFF2C2C2C)),
                    _buildButton('÷', textColor: Colors.deepOrange, bgColor: const Color(0xFF2C2C2C)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×', textColor: Colors.deepOrange, bgColor: const Color(0xFF2C2C2C)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', textColor: Colors.deepOrange, bgColor: const Color(0xFF2C2C2C)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', textColor: Colors.deepOrange, bgColor: const Color(0xFF2C2C2C)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('=', textColor: Colors.white, bgColor: Colors.deepOrange),
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
