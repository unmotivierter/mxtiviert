import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(Calc());
}

class Calc extends StatefulWidget {
  const Calc({super.key});

  @override
  State<Calc> createState() => _CalcState();
}

enum Operators { add, subtract, multiply, divide, equal}

class _CalcState extends State<Calc> {
  double num1 = 0;
  double num2 = 0;
  bool num1Selected = true;
  bool num2Selected = false;
  double res = 0;
  var oper = Operators.add;

  var formatter = NumberFormat("0.####");

  void setRes(double n1) {
    setState(() {
      num1 = n1;
    });
  }

  String toPrint(){
    if(oper == Operators.equal) return formatter.format(res);
    if(num1Selected) return formatter.format(num1);
    String temp = formatter.format(num1);   
    switch(oper){
      case Operators.add: temp += "+"; break;
      case Operators.subtract: temp += "-"; break;
      case Operators.multiply: temp += "*"; break;
      case Operators.divide: temp += "/"; break;
      default: break;
    }
    if(!num2Selected) return temp;
    temp += formatter.format(num2);
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              DisplayBar(toDisplay: toPrint()),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 25,
            color: Colors.blueGrey.shade800,
            child: Align( 
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Text(toDisplay, style: TextStyle(color: Colors.green, fontSize: 15)),
              ),
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 50,
            color: Colors.black,
            child: Align( 
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Text(toDisplay, style: TextStyle(color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final Function(double) updateNums;

  const Buttons({super.key, required this.updateNums});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){updateNums(1223412.234);}, child: Icon(Icons.numbers));
  }
}
