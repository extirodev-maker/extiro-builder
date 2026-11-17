import 'extiro_watermark.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ExtiroWatermark(child: const SmartCalcApp()));
}

class SmartCalcApp extends StatelessWidget {
  const SmartCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartCalc',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFFEC4899),
          surface: Color(0xFF1E293B),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
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
  bool _isNewOp = false;
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('calc_history') ?? [];
    });
  }

  _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('calc_history', _history);
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _output = '0';
        _expression = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
      } else if (buttonText == '⌫') {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = '0';
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        _num1 = double.tryParse(_output) ?? 0;
        _operand = buttonText;
        _expression = '$_output $_operand';
        _isNewOp = true;
      } else if (buttonText == '.') {
        if (_isNewOp) {
          _output = '0.';
          _isNewOp = false;
        } else if (!_output.contains('.')) {
          _output = _output + '.';
        }
      } else if (buttonText == '=') {
        _num2 = double.tryParse(_output) ?? 0;
        double result = 0;
        if (_operand == '+') result = _num1 + _num2;
        if (_operand == '-') result = _num1 - _num2;
        if (_operand == '×') result = _num1 * _num2;
        if (_operand == '÷') {
          if (_num2 == 0) {
            _output = 'Error';
            return;
          }
          result = _num1 / _num2;
        }
        String resStr = (result == result.toInt()) ? result.toInt().toString() : result.toStringAsFixed(4);
        String histItem = '$_expression $_num2 = $resStr';
        _history.insert(0, histItem);
        if (_history.length > 20) _history.removeLast();
        _saveHistory();

        _expression = '';
        _output = resStr;
        _isNewOp = true;
      } else {
        if (_output == '0' || _isNewOp) {
          _output = buttonText;
          _isNewOp = false;
        } else {
          _output = _output + buttonText;
        }
      }
    });
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 22),
            backgroundColor: color ?? const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showHistoryModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Calculation History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        _history.clear();
                        _saveHistory();
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              const Divider(color: Colors.white24),
              Expanded(
                child: _history.isEmpty
                    ? const Center(child: Text('No history yet', style: TextStyle(color: Colors.white54)))
                    : ListView.builder(
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_history[index], style: const TextStyle(fontSize: 18, color: Colors.white70)),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('SmartCalc', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showHistoryModal,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 20, color: Colors.white54),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _output,
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF162032),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('AC', color: const Color(0xFFEF4444), textColor: Colors.white),
                    _buildButton('⌫', color: const Color(0xFF334155), textColor: Colors.amber),
                    _buildButton('%', color: const Color(0xFF334155), textColor: Colors.amber),
                    _buildButton('÷', color: const Color(0xFF6366F1), textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7', color: const Color(0xFF1E293B)),
                    _buildButton('8', color: const Color(0xFF1E293B)),
                    _buildButton('9', color: const Color(0xFF1E293B)),
                    _buildButton('×', color: const Color(0xFF6366F1), textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4', color: const Color(0xFF1E293B)),
                    _buildButton('5', color: const Color(0xFF1E293B)),
                    _buildButton('6', color: const Color(0xFF1E293B)),
                    _buildButton('-', color: const Color(0xFF6366F1), textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1', color: const Color(0xFF1E293B)),
                    _buildButton('2', color: const Color(0xFF1E293B)),
                    _buildButton('3', color: const Color(0xFF1E293B)),
                    _buildButton('+', color: const Color(0xFF6366F1), textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('00', color: const Color(0xFF1E293B)),
                    _buildButton('0', color: const Color(0xFF1E293B)),
                    _buildButton('.', color: const Color(0xFF1E293B)),
                    _buildButton('=', color: const Color(0xFFEC4899), textColor: Colors.white),
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
