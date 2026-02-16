import 'package:flutter/material.dart';

void main() {
  runApp(Calc());
}

class Calc extends StatefulWidget {
  const Calc({super.key});

  @override
  State<Calc> createState() => _CalcState();
}

enum Operators { add, subtract, multiply, divide, equal, clear }

class _CalcState extends State<Calc> {
  double num1 = 0;
  double num2 = 0;
  bool num1Selected = true;
  double res = 0;
  var oper;

  void setRes() {
    setState(() {
      num1Selected = true;
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
      }
    });
  }

  void clear() {
    setState(() {
      num1 = 0;
      num2 = 0;
      res = 0;
      num1Selected = true;
      setRes();
    });
  }

  void handleOperations(Operators op) {
    if (op == Operators.equal) {
      setRes();
    } else if (op == Operators.clear) {
      clear();
    } else {
      oper = op;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              DisplayBar(toDisplay: "$num1 and $num2 equals $res"),
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
                      Buttons(updateNums: setNum, id: 4),
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
    return Container(child: Text(toDisplay));
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
