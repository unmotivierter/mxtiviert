import 'package:flutter/material.dart';

void main() {
  runApp(Calc());
}

class Calc extends StatefulWidget {
  const Calc({super.key});

  @override
  State<Calc> createState() => _CalcState();
}

class _CalcState extends State<Calc> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: DisplayBar(to_display: "Halllloooooo")),
    );
  }
}

class DisplayBar extends StatelessWidget {
  const DisplayBar({super.key, required this.to_display});

  final String to_display;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(to_display));
  }
}
