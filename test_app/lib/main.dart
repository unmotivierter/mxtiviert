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

enum Operators {
  none,
  add,
  subtract,
  multiply,
  divide,
  equal,
  clear,
  signed,
  dot,
}

class _CalcState extends State<Calc> {
  double num1 = 0;
  double num2 = 0;
  bool num1Selected = true;
  bool num2Selected = false;
  double res = 0;
  String displayText1 = "";
  String displayText2 = "";
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
      num2 = 0;
    });
  }

  void setNum(int n) {
    setState(() {
      if (oper == Operators.equal) {
        num1Selected = true;
        oper = Operators.none;
        num1 = 0;
      }
      if (num1Selected) {
        num1 *= 10;
        num1 += n.toDouble();
      } else {
        num2 *= 10;
        num2 += n.toDouble();
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

  void handleOperations(Operators op) {
    setState(() {
      if (op == Operators.equal) {
        setRes();
        num1Selected = true;
        num2Selected = false;
      } else if (op == Operators.clear) {
        clear();
      } else {
        if (oper == Operators.equal) num1 = res;
        num1Selected = false;
      }
      oper = op;
    });
  }

  String toPrint() {
    if (oper == Operators.equal) {
      setState(() {
        displayText2 = displayText1;
      });
      return formatter.format(res);
    }
    if (displayText2.isNotEmpty) displayText2 = "";
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
    setState(() {
      displayText1 = temp;
    });
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
              DisplayBar(toDisplay: toPrint(), toDisplay2: displayText2),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Column(
                        children: [
                          Buttons(updateNums: setNum, id: 7),
                          Buttons(updateNums: setNum, id: 4),
                          Buttons(updateNums: setNum, id: 1),
                          ActionButtons(
                            updateOp: handleOperations,
                            op: Operators.signed,
                          ),
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
                          ActionButtons(
                            updateOp: handleOperations,
                            op: Operators.dot,
                          ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayBar extends StatelessWidget {
  const DisplayBar({
    super.key,
    required this.toDisplay,
    required this.toDisplay2,
  });

  final String toDisplay;
  final String toDisplay2;

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
                  toDisplay2,
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width / 5,
        height: MediaQuery.sizeOf(context).width / 5,
        child: ElevatedButton(
          onPressed: () {
            updateNums(id);
          },
          child: Text("$id"),
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final Function(Operators) updateOp;
  final Operators op;

  const ActionButtons({super.key, required this.updateOp, required this.op});

  @override
  Widget build(BuildContext context) {
    String txt;
    switch (op) {
      case Operators.add:
        txt = "+";
        break;
      case Operators.subtract:
        txt = "-";
        break;
      case Operators.multiply:
        txt = "*";
        break;
      case Operators.divide:
        txt = "/";
        break;
      case Operators.clear:
        txt = "AC";
        break;
      case Operators.equal:
        txt = "=";
        break;
      case Operators.dot:
        txt = ".";
        break;
      case Operators.signed:
        txt = "+/-";
        break;
      default:
        txt = "errrrroooro";
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width / 5,
        height: MediaQuery.sizeOf(context).width / 5,
        child: ElevatedButton(
          onPressed: () {
            updateOp(op);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade600,
          ),
          //width: MediaQuery.sizeOf(context).width,
          child: Text(txt),
        ),
      ),
    );
  }
}
