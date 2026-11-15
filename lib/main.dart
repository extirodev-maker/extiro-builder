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
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = '0';
  String _input = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _input = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        _num1 = double.tryParse(_output) ?? 0;
        _operand = buttonText;
        _input = '';
      } else if (buttonText == '=') {
        _num2 = double.tryParse(_output) ?? 0;
        if (_operand == '+') {
          _output = (_num1 + _num2).toString();
        } else if (_operand == '-') {
          _output = (_num1 - _num2).toString();
        } else if (_operand == '×') {
          _output = (_num1 * _num2).toString();
        } else if (_operand == '÷') {
          _output = _num2 != 0 ? (_num1 / _num2).toString() : 'Error';
        }
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
        }
        _operand = '';
        _input = '';
      } else {
        if (_output == '0' || _input == '0') {
          _output = buttonText;
        } else {
          _output = _output + buttonText;
        }
        _input = _output;
      }
    });
  }

  Widget _buildButton(String buttonText, Color textColor, Color bgColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.all(22.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 2,
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
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
        title: const Text('Extiro Calculator'),
        backgroundColor: const Color(0xFF1F1F1F),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Column(
            children: [
              Row(
                children: [
                  _buildButton('C', Colors.redAccent, const Color(0xFF2C2C2C)),
                  _buildButton('÷', Colors.orange, const Color(0xFF2C2C2C)),
                  _buildButton('×', Colors.orange, const Color(0xFF2C2C2C)),
                  _buildButton('-', Colors.orange, const Color(0xFF2C2C2C)),
                ],
              ),
              Row(
                children: [
                  _buildButton('7', Colors.white, const Color(0xFF333333)),
                  _buildButton('8', Colors.white, const Color(0xFF333333)),
                  _buildButton('9', Colors.white, const Color(0xFF333333)),
                  _buildButton('+', Colors.orange, const Color(0xFF2C2C2C)),
                ],
              ),
              Row(
                children: [
                  _buildButton('4', Colors.white, const Color(0xFF333333)),
                  _buildButton('5', Colors.white, const Color(0xFF333333)),
                  _buildButton('6', Colors.white, const Color(0xFF333333)),
                  _buildButton('=', Colors.white, Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('1', Colors.white, const Color(0xFF333333)),
                  _buildButton('2', Colors.white, const Color(0xFF333333)),
                  _buildButton('3', Colors.white, const Color(0xFF333333)),
                  _buildButton('0', Colors.white, const Color(0xFF333333)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
