import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: 'Basics',
    home: FirstApp(),
  ));
}

class FirstApp extends StatelessWidget {
  const FirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Route')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute<void>(
                builder: (context) => SecondRoute(),
                ),
              );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Route')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThirdRoute(),
                  )
                );
              },
              child: const Text('Go further!'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.reddit_outlined),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class ThirdRoute extends StatelessWidget{
  const ThirdRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.pop(
              context,
            );
          }, 
          child: Icon(Icons.reddit_rounded)
          ),
      ),
    );
  }
}
