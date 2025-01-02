import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _expression = "";
  bool _newCalculation = false;

  void _buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        _output = "0";
        _expression = "";
        _newCalculation = false;
      } else if (value == "=") {
        if (_expression.isNotEmpty) {
          try {
            _output = _calculateOutput();
            _expression = _output;
            _newCalculation = true;
          } catch (e) {
            _output = "Error";
            _expression = "";
          }
        }
      } else {
        if (_newCalculation) {
          _expression = "";
          _newCalculation = false;
        }
        if (_output == "0" && value != ".") {
          _expression = value;
        } else {
          _expression += value;
        }
        _output = _expression;
      }
    });
  }

  String _calculateOutput() {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(_expression.replaceAll('×', '*').replaceAll('÷', '/'));
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString().replaceAll(RegExp(r'\.0\$'), '');
    } catch (e) {
      return "Error";
    }
  }

  Widget _buildButton(String label, {Color? textColor}) {
    if (label.trim().isEmpty) {
      return const SizedBox.shrink(); // Bo'sh joy qaytaradi
    }

    return ElevatedButton(
      onPressed: () => _buttonPressed(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEDFFFF),
        foregroundColor: textColor ?? const Color(0xFF424250),
        shape: const RoundedRectangleBorder(),
        padding: const EdgeInsets.all(16),
        elevation: 0,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            color: textColor ?? const Color(0xFF424250),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB0DFE5),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerRight,
                color: Colors.white,
                height: 50,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _output,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Buttons
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                  _buildButton("C", textColor: Colors.red),
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                  _buildButton("+", textColor: Colors.red),
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                  _buildButton("-", textColor: Colors.red),
                  _buildButton(" ", textColor: Colors.red),

                  _buildButton("0"),
                  _buildButton("."),
                  _buildButton("=", textColor: Colors.red),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
