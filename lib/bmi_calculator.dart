import 'package:flutter/material.dart';

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String _result = '';
  double? _bmi;

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;
    int age = int.tryParse(ageController.text) ?? 0;

    if (height <= 0 || weight <= 0 || age <= 0) {
      setState(() {
        _result = "Masukkan tinggi, berat, dan umur yang valid";
        _bmi = null;
      });
      return;
    }

    double bmi = weight / ((height / 100) * (height / 100));
    String category;
    String advice = "";

    if (bmi < 18.5) {
      category = "Kurus";
      advice = "Cobalah untuk meningkatkan asupan kalori dan konsultasikan ke ahli gizi.";
    } else if (bmi < 25) {
      category = "Normal";
      advice = "Bagus! Jaga terus pola makan dan gaya hidup sehatmu.";
    } else if (bmi < 30) {
      category = "Gemuk";
      advice = "Mulailah atur pola makan dan tambahkan aktivitas fisik.";
    } else {
      category = "Obesitas";
      advice = "Disarankan untuk mulai program diet sehat dan olahraga rutin.";
    }

    setState(() {
      _bmi = bmi;
      _result = "BMI: ${bmi.toStringAsFixed(2)} ($category), Umur: $age tahun\n$advice";
    });
  }

  Color getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  double getBMIProgress(double bmi) {
    if (bmi <= 0) return 0;
    return (bmi.clamp(10.0, 40.0) - 10.0) / 30.0;
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Kalkulator BMI"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildInputField("Tinggi (cm)", heightController),
            buildInputField("Berat (kg)", weightController),
            buildInputField("Umur (tahun)", ageController),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: calculateBMI,
                child: Text(
                  "Hitung BMI",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 30),
            if (_bmi != null)
              Column(
                children: [
                  LinearProgressIndicator(
                    value: getBMIProgress(_bmi!),
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(getBMIColor(_bmi!)),
                    minHeight: 20,
                  ),
                  SizedBox(height: 15),
                ],
              ),
            Text(
              _result,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}