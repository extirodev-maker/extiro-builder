import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF171821),
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
  String _input = '';
  String _operand = '';
  double _num1 = 0;
  double _num2 = 0;
  bool _isResultShown = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _output = '0';
        _input = '';
        _operand = '';
        _num1 = 0;
        _num2 = 0;
        _isResultShown = false;
      } else if (buttonText == '⌫') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
          if (_input.isEmpty) {
            _output = '0';
          } else {
            _output = _input;
          }
        }
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '×' ||
          buttonText == '÷') {
        if (_input.isNotEmpty) {
          _num1 = double.parse(_input);
          _operand = buttonText;
          _input = '';
        }
      } else if (buttonText == '%') {
        if (_input.isNotEmpty) {
          _num1 = double.parse(_input);
          _output = (_num1 / 100).toString();
          _input = _output;
        }
      } else if (buttonText == '.') {
        if (!_input.contains('.')) {
          _input += buttonText;
          _output = _input;
        }
      } else if (buttonText == '=') {
        if (_input.isNotEmpty && _operand.isNotEmpty) {
          _num2 = double.parse(_input);
          if (_operand == '+') {
            _output = (_num1 + _num2).toString();
          } else if (_operand == '-') {
            _output = (_num1 - _num2).toString();
          } else if (_operand == '×') {
            _output = (_num1 * _num2).toString();
          } else if (_operand == '÷') {
            _output = _num2 != 0 ? (_num1 / _num2).toString() : 'Error';
          }
          
          // Remove trailing .0 for clean integer outputs
          if (_output.endsWith('.0')) {
            _output = _output.substring(0, _output.length - 2);
          }
          
          _input = _output;
          _operand = '';
          _isResultShown = true;
        }
      } else {
        if (_isResultShown) {
          _input = buttonText;
          _isResultShown = false;
        } else {
          _input += buttonText;
        }
        _output = _input;
      }
    });
  }

  Widget _buildButton(String text, {Color? textColor, Color? bgColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(22.0),
            backgroundColor: bgColor ?? const Color(0xFF21222D),
            foregroundColor: textColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0,
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
        title: const Text('Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24.0),
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E29),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('AC', textColor: Colors.redAccent, bgColor: const Color(0xFF2A2B36)),
                    _buildButton('%', textColor: Colors.amber, bgColor: const Color(0xFF2A2B36)),
                    _buildButton('⌫', textColor: Colors.amber, bgColor: const Color(0xFF2A2B36)),
                    _buildButton('÷', textColor: Colors.orange, bgColor: const Color(0xFF2A2B36)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×', textColor: Colors.orange, bgColor: const Color(0xFF2A2B36)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', textColor: Colors.orange, bgColor: const Color(0xFF2A2B36)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', textColor: Colors.orange, bgColor: const Color(0xFF2A2B36)),
                  ],
                },
                Row(
                  children: [
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('=', textColor: Colors.white, bgColor: Colors.orange),
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
