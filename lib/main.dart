import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(PastelCalculator());

class PastelCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastel Calculator',
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = '';
  String result = '';
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playClickSound() async {
    await _audioPlayer.play(AssetSource('sounds/click.mp3'));
  }

  void _onPressed(String value) {
    _playClickSound();
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
      } else if (value == 'DEL') {
        if (input.isNotEmpty) input = input.substring(0, input.length - 1);
      } else if (value == '=') {
        result = _calculateResult(input);
      } else {
        input += value;
      }
    });
  }

  String _calculateResult(String input) {
    try {
      String expression = input.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval % 1 == 0 ? eval.toInt().toString() : eval.toString();
    } catch (e) {
      return 'Error';
    }
  }

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5F9),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    input,
                    style: TextStyle(fontSize: 32, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    result,
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[300]),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final label = buttons[index];
                final isOperator =
                    ['%', '÷', '×', '-', '+', '='].contains(label);
                return ElevatedButton(
                  onPressed: () => _onPressed(label),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOperator
                        ? Colors.blue[100]
                        : (label == 'C' || label == 'DEL')
                            ? Colors.pink[100]
                            : Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(20),
                    elevation: 3,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
