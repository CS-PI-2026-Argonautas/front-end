import 'package:flutter/material.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold (
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(150.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(decoration: InputDecoration(hintText: 'Login', border: OutlineInputBorder( 
                borderSide: BorderSide(
                  color: Colors.blue
                )
              )),)
            ],
          ),
          ),
        ),
      ),
    );
    }
}

