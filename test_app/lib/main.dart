import 'package:flutter/material.dart';

void main(){
  runApp(FirstApp());
}

class FirstApp extends StatefulWidget {
  const FirstApp({super.key});

  @override
  State<FirstApp> createState() => _FirstAppState();
}

class _FirstAppState extends State<FirstApp> {
  var verified = false;

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            foregroundColor: Colors.purple,
            backgroundColor: Colors.blue,
            elevation: 0.2,
            title: const Text('Flutter flutscht'),
          ),
        body: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                  Container(
                    color: Colors.blueGrey,
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(10),
                    child: const Text('Wo ist PePe', style: TextStyle(color: Colors.amber),),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.add, color: Colors.red,),
                  )
                  ]
                ),
                Icon(Icons.heart_broken),
                SizedBox(
                  child: Icon(Icons.abc),
                ),
              ]
            ),
            Container(
              height: 500,
              width: 500,
              color: Colors.yellow,
              child: Text('verified: $verified')
            ),
            Container(
              height: 500,
              width: 1000,
              color: Colors.green,
              child: const Text('Dasselbe in grün')
            ),
          ]
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.verified),
          onPressed: (){
            setState(() {
              verified = !verified;
            });
            print("verified: $verified");
          }
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: "work",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.headphones),
              label: "Head",
            ),
          ],
          ),
          drawer: Drawer(
            child: const Text('Yo!'),
          ),
      ),
    );
  }
}