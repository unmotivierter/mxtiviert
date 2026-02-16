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

enum Operators { none, add, subtract, multiply, divide, equal, clear }

class _CalcState extends State<Calc> {
  double num1 = 0;
  double num2 = 0;
  bool num1Selected = true;
  bool num2Selected = false;
  double res = 0;
  var oper = Operators.none;

  var formatter = NumberFormat("0.####");

  void setRes() {
    setState(() {
      num1Selected = true;
      num2Selected = false;
      switch (oper) {
        case Operators.add:
          res = num1 + num2;
          break;
        case Operators.subtract:
          res = num1 - num2;
          break;
        case Operators.multiply:
          res = num1 * num2;
          break;
        case Operators.divide:
          res = num1 / num2;
          break;
        default:
          break;
      }
    });
  }

  void setNum(int n1) {
    setState(() {
      if (num1Selected) {
        num1 = n1.toDouble();
        num1Selected = false;
      } else {
        num2 = n1.toDouble();
        num2Selected = true;
      }
    });
  }

  void clear() {
    setState(() {
      num1 = 0;
      num2 = 0;
      res = 0;
      num1Selected = true;
      oper = Operators.none;
      setRes();
    });
  }

  String toPrint() {
    if (oper == Operators.equal){
      setState((){
        oper = Operators.none;
        num1Selected = true;
        num2Selected = false;
      });
      return formatter.format(res);
    }
    if (num1Selected) return formatter.format(num1);
    String temp = formatter.format(num1);
    switch (oper) {
      case Operators.add:
        temp += "+";
        break;
      case Operators.subtract:
        temp += "-";
        break;
      case Operators.multiply:
        temp += "*";
        break;
      case Operators.divide:
        temp += "/";
        break;
      default:
        break;
    }
    if (!num2Selected) return temp;
    temp += formatter.format(num2);
    return temp;
  }

  void handleOperations(Operators op) {
    setState((){
    if (op == Operators.equal) {
      setRes();
    } else if (op == Operators.clear) {
      clear();
    }
    oper = op;
    });
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Buttons(updateNums: setNum, id: 7),
                      Buttons(updateNums: setNum, id: 4),
                      Buttons(updateNums: setNum, id: 1),
                    ],
                  ),

                  Column(
                    children: [
                      Buttons(updateNums: setNum, id: 8),
                      Buttons(updateNums: setNum, id: 5),
                      Buttons(updateNums: setNum, id: 2),
                      Buttons(updateNums: setNum, id: 0),
                    ],
                  ),

                  Column(
                    children: [
                      Buttons(updateNums: setNum, id: 9),
                      Buttons(updateNums: setNum, id: 6),
                      Buttons(updateNums: setNum, id: 3),
                    ],
                  ),
                  Column(
                    children: [
                      ActionButtons(
                        updateOp: handleOperations,
                        op: Operators.add,
                      ),
                      ActionButtons(
                        updateOp: handleOperations,
                        op: Operators.subtract,
                      ),
                      ActionButtons(
                        updateOp: handleOperations,
                        op: Operators.multiply,
                      ),
                      ActionButtons(
                        updateOp: handleOperations,
                        op: Operators.divide,
                      ),
                      ActionButtons(
                        updateOp: handleOperations,
                        op: Operators.equal,
                      ),
                      ActionButtons(
                        updateOp: handleOperations,
                        op: Operators.clear,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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
                child: Text(
                  toDisplay,
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
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
                child: Text(
                  toDisplay,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final Function(int) updateNums;
  final int id;

  const Buttons({super.key, required this.updateNums, required this.id});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        updateNums(id);
      },
      child: Text("$id"),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final Function(Operators) updateOp;
  final Operators op;

  const ActionButtons({super.key, required this.updateOp, required this.op});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        updateOp(op);
      },
      child: Text("$op"),
    );
  }
}
