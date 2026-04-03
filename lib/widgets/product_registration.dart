import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductRegistration extends StatelessWidget {
  const ProductRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product regist',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 64, 126, 207),

        body: Center(
          child: Card(
            child: Form(
              child: Container(
                width: 900,

                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Center(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: "ID",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Enviar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
