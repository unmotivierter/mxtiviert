import 'package:flutter/material.dart';

void main() {
  runApp(Calc());
}

class Calc extends StatefulWidget {
  const Calc({super.key});

  @override
  State<Calc> createState() => _CalcState();
}

enum Operators { add, subtract, multiply, divide }

class _CalcState extends State<Calc> {
  double num1 = 0;
  double num2 = 0;
  double res = 0;
  var oper = Operators.add;

  void setRes(double n1) {
    setState(() {
      res = n1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              DisplayBar(toDisplay: "$res"),
              Buttons(updateNums: setRes),
            ],
          )),
      ),
    );
  }
}

class DisplayBar extends StatelessWidget {
  const DisplayBar({super.key, required this.toDisplay});

  final String toDisplay;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(toDisplay));
  }
}

class Buttons extends StatelessWidget {
  final Function(double) updateNums;

  const Buttons({super.key, required this.updateNums});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){updateNums(12);}, child: Icon(Icons.numbers));
  }
}
