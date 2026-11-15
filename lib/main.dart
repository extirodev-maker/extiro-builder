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
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({Key? key}) : super(key: key);

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = '0';
  String _currentInput = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _output = '0';
        _currentInput = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
      } else if (buttonText == '⌫') {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          _output = _currentInput.isEmpty ? '0' : _currentInput;
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        if (_currentInput.isNotEmpty) {
          _num1 = double.parse(_currentInput);
          _operand = buttonText;
          _currentInput = '';
        } else if (_output != '0') {
          _num1 = double.parse(_output);
          _operand = buttonText;
        }
      } else if (buttonText == '.') {
        if (!_currentInput.contains('.')) {
          _currentInput += '.';
          _output = _currentInput;
        }
      } else if (buttonText == '=') {
        if (_operand.isNotEmpty && _currentInput.isNotEmpty) {
          _num2 = double.parse(_currentInput);
          if (_operand == '+') {
            _output = (_num1 + _num2).toString();
          } else if (_operand == '-') {
            _output = (_num1 - _num2).toString();
          } else if (_operand == '×') {
            _output = (_num1 * _num2).toString();
          } else if (_operand == '÷') {
            _output = _num2 == 0 ? 'Error' : (_num1 / _num2).toString();
          }
          // Clean up trailing .0 for integer results
          if (_output.endsWith('.0')) {
            _output = _output.substring(0, _output.length - 2);
          }
          _currentInput = _output;
          _operand = '';
        }
      } else {
        if (_currentInput == '0') {
          _currentInput = buttonText;
        } else {
          _currentInput += buttonText;
        }
        _output = _currentInput;
      }
    });
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color(0xFF1E1E1E),
            foregroundColor: textColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 22),
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
        title: const Text('Calculator by Extiro AI'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('AC', color: Colors.grey[850], textColor: Colors.orangeAccent),
                    _buildButton('⌫', color: Colors.grey[850], textColor: Colors.orangeAccent),
                    _buildButton('÷', color: Colors.orange[800]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×', color: Colors.orange[800]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', color: Colors.orange[800]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', color: Colors.orange[800]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('=', color: Colors.green[700]),
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
