import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.deepOrange,
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
  String _output = "0";
  String _input = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operand = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _input = "";
        _num1 = 0;
        _num2 = 0;
        _operand = "";
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
        _num1 = double.tryParse(_output) ?? 0;
        _operand = buttonText;
        _input = "";
      } else if (buttonText == ".") {
        if (!_input.contains(".")) {
          _input += buttonText;
          _output = _input;
        }
      } else if (buttonText == "=") {
        _num2 = double.tryParse(_output) ?? 0;
        if (_operand == "+") {
          _output = (_num1 + _num2).toString();
        } else if (_operand == "-") {
          _output = (_num1 - _num2).toString();
        } else if (_operand == "×") {
          _output = (_num1 * _num2).toString();
        } else if (_operand == "÷") {
          _output = _num2 != 0 ? (_num1 / _num2).toString() : "Error";
        }
        if (_output.endsWith(".0")) {
          _output = _output.substring(0, _output.length - 2);
        }
        _operand = "";
        _input = _output;
      } else {
        if (_output == "0" || _input == _output) {
          _input = buttonText;
        } else {
          _input += buttonText;
        }
        _output = _input;
      }
    });
  }

  Widget _buildButton(String buttonText, {Color color = const Color(0xFF1E1E1E), Color textColor = Colors.white}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            elevation: 2,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extiro Calculator', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                style: const TextStyle(fontSize: 64.0, fontWeight: FontWeight.w300, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Column( 
            children: [
              Row(children: [
                _buildButton("C", color: Colors.redAccent.withOpacity(0.2), textColor: Colors.redAccent),
                _buildButton("÷", color: Colors.deepOrange, textColor: Colors.white),
                _buildButton("×", color: Colors.deepOrange, textColor: Colors.white),
              ]),
              Row(children: [
                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("-", color: Colors.deepOrange, textColor: Colors.white),
              ]),
              Row(children: [
                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("+", color: Colors.deepOrange, textColor: Colors.white),
              ]),
              Row(children: [
                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("=", color: Colors.orange, textColor: Colors.white),
              ]),
              Row(children: [
                _buildButton("0"),
                _buildButton("."),
              ]),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
