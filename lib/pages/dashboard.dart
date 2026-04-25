import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_Corlors;

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dashboard",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: custom_Corlors.colorScheme.surface,
        body: SafeArea(child: Column(children: [
          
         ],
         )),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
