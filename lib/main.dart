import 'package:flutter/material.dart';
import 'category.dart';
import 'product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Operation Using SQLite and SQFlite',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'SQLite CRUD Operation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Category()));
              },
              child: Text(
                'Category',
                style: TextStyle(fontSize: 30),
              ),
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all<Size>(Size.fromWidth(300)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.all(20),
                  )),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Product()));
              },
              child: Text(
                'Product',
                style: TextStyle(fontSize: 30),
              ),
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all<Size>(Size.fromWidth(300)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.all(20),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
