import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'advanced_calculator.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Splash screen tetap jadi halaman pertama
      routes: {
        '/advanced': (context) => const AdvancedCalculatorPage(), // ✅ ROUTE baru
      },
    );
  }
}


class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({super.key});

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (buttonText == "⌫") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation.isEmpty) {
          equation = "0";
        }
      } else if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        try {
          ShuntingYardParser p = ShuntingYardParser();
          Expression exp = p.parse(equation);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';

          // Handle decimal places
          if (result.endsWith('.0')) {
            result = result.substring(0, result.length - 2);
          }
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation += buttonText;
        }
      }
    });
  }

  Widget _buildButton(String buttonText, Color buttonColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.white, width: 1),
        ),
        padding: const EdgeInsets.all(16.0),
        textStyle: const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      onPressed: () => buttonPressed(buttonText),
      child: Text(buttonText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.science),
            onPressed: () => Navigator.pushNamed(context, '/advanced'),
            tooltip: 'Mode Scientific',
          ),
        ],
      ),
      body: Column(
        children: [
          // Display area
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      equation,
                      style: TextStyle(fontSize: equationFontSize),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      result,
                      style: TextStyle(
                        fontSize: resultFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Buttons area
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // First row
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildButton("C", Colors.redAccent)),
                      Expanded(child: _buildButton("⌫", Colors.redAccent)),
                      Expanded(child: _buildButton("/", Colors.blue)),
                    ],
                  ),
                ),

                // Number rows
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildButton("7", Colors.black54)),
                      Expanded(child: _buildButton("8", Colors.black54)),
                      Expanded(child: _buildButton("9", Colors.black54)),
                      Expanded(child: _buildButton("*", Colors.blue)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildButton("4", Colors.black54)),
                      Expanded(child: _buildButton("5", Colors.black54)),
                      Expanded(child: _buildButton("6", Colors.black54)),
                      Expanded(child: _buildButton("-", Colors.blue)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildButton("1", Colors.black54)),
                      Expanded(child: _buildButton("2", Colors.black54)),
                      Expanded(child: _buildButton("3", Colors.black54)),
                      Expanded(child: _buildButton("+", Colors.blue)),
                    ],
                  ),
                ),

                // Last row
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildButton(".", Colors.black54)),
                      Expanded(child: _buildButton("0", Colors.black54)),
                      Expanded(child: _buildButton("00", Colors.black54)),
                      Expanded(
                        child: _buildButton("=", Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}