import 'package:flutter/material.dart';

void main() {
  runApp(Calc());
}

class Calc extends StatefulWidget {
  const Calc({super.key});


  @override
  State<Calc> createState() => _CalcState();
}

enum Operators{
  add, 
  subtract,
  multiply,
  divide,
}


class _CalcState extends State<Calc> {

  double num1 = 0;
  double num2 = 0;
  var oper = Operators.add;

  double addNums(double n1, double n2){
    return n1 + n2;
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: DisplayBar(toDisplay: "Halllloooooo")),
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
