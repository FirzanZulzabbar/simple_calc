import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class AdvancedCalculatorPage extends StatefulWidget {
  const AdvancedCalculatorPage({super.key});

  @override
  State<AdvancedCalculatorPage> createState() => _AdvancedCalculatorPageState();
}

class _AdvancedCalculatorPageState extends State<AdvancedCalculatorPage> {
  String expression = '';
  String result = '';

  void _addToExpression(String value) {
    setState(() {
      expression += value;
    });
  }

  void _evaluate() {
    try {
      final parser = ShuntingYardParser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        result = eval.toString();
        // Remove .0 if the result is integer
        if (result.endsWith('.0')) {
          result = result.substring(0, result.length - 2);
        }
      });
    } catch (e) {
      setState(() {
        result = 'Error';
      });
    }
  }

  void _clear() {
    setState(() {
      expression = '';
      result = '';
    });
  }

  void _deleteLastChar() {
    if (expression.isNotEmpty) {
      setState(() {
        expression = expression.substring(0, expression.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalkulator Lanjutan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Display area
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  expression,
                  style: const TextStyle(fontSize: 24),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  result,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Scientific buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildButton('π', '3.141592'),
              _buildButton('e', '2.71828'),
              _buildButton('x²', '^2'),
              _buildButton('x^y', '^'),
              _buildButton('√', 'sqrt('),
              _buildButton('log', 'log('),
              _buildButton('ln', 'ln('),
              _buildButton('sin', 'sin('),
              _buildButton('cos', 'cos('),
              _buildButton('tan', 'tan('),
            ],
          ),

          const SizedBox(height: 10),

          // Basic calculator buttons - now with more space
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
              padding: const EdgeInsets.all(8),
              children: [
                // First row
                _buildButton('C', 'clear', isFunction: true),
                _buildButton('⌫', 'delete', isFunction: true),
                _buildButton('/', '/'),
                _buildButton('*', '*'),

                // Number rows
                _buildButton('7', '7'),
                _buildButton('8', '8'),
                _buildButton('9', '9'),
                _buildButton('-', '-'),

                _buildButton('4', '4'),
                _buildButton('5', '5'),
                _buildButton('6', '6'),
                _buildButton('+', '+'),

                // Last row
                _buildButton('1', '1'),
                _buildButton('2', '2'),
                _buildButton('3', '3'),
                _buildButton('=', '=', isFunction: true),

                _buildButton('0', '0'),
                _buildButton('.', '.'),
                _buildButton('(', '('),
                _buildButton(')', ')'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, String value, {bool isFunction = false}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          if (isFunction) {
            if (value == 'clear') {
              _clear();
            } else if (value == 'delete') {
              _deleteLastChar();
            } else if (value == '=') {
              _evaluate();
            }
          } else {
            _addToExpression(value);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}