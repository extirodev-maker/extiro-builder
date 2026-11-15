import 'package:flutter/material.dart';

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
  String _expression = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';
  bool _isNewOperand = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
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
      } else if (buttonText == '.') {
        if (_isNewOperand) {
          _output = '0.';
          _isNewOperand = false;
        } else if (!_output.contains('.')) {
          _output = '$_output.';
        }
      } else if (buttonText == '%') {
        double val = (double.tryParse(_output) ?? 0) / 100;
        _output = val.toString();
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
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
          result = _num2 == 0 ? 0 : _num1 / _num2;
        }

        // Clean up decimal if integer
        if (result == result.toInt()) {
          _output = result.toInt().toString();
        } else {
          _output = result.toString();
        }
        _operand = '';
        _isNewOperand = true;
      } else {
        // Numbers 0-9
        if (_output == '0' || _isNewOperand) {
          _output = buttonText;
          _isNewOperand = false;
        } else {
          _output = _output + buttonText;
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
            backgroundColor: bgColor ?? const Color(0xFF1E1E1E),
            foregroundColor: textColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 22),
            elevation: 2,
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
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
        title: const Text('Extiro Calculator', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(
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
                      style: const TextStyle(
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
          const Divider(height: 1, color: Colors.white12),
          // Keypad Area
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton('AC', textColor: Colors.redAccent, bgColor: const Color(0xFF2A1515)),
                      _buildButton('⌫', textColor: Colors.orangeAccent, bgColor: const Color(0xFF2A2215)),
                      _buildButton('%', textColor: Colors.orangeAccent, bgColor: const Color(0xFF2A2215)),
                      _buildButton('÷', textColor: Colors.deepOrange, bgColor: const Color(0xFF2A1C15)),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('×', textColor: Colors.deepOrange, bgColor: const Color(0xFF2A1C15)),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('-', textColor: Colors.deepOrange, bgColor: const Color(0xFF2A1C15)),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('+', textColor: Colors.deepOrange, bgColor: const Color(0xFF2A1C15)),
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
          ),
        ],
      ),
    );
  }
}
