import 'package:flutter/material.dart';
import 'package:frontend/pages/authentication.dart';
import 'package:frontend/pages/product_registration/product_registration.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_Colors;
import 'package:frontend/widgets/bottom_bar.dart';
import 'package:frontend/pages/stand_in_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: custom_Colors.colorScheme.surface,
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: custom_Colors.colorScheme.primary,
        foregroundColor: custom_Colors.colorScheme.onPrimary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [custom_Colors.colorScheme.primary, custom_Colors.colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Authentication()),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: custom_Colors.colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.arrow_back),
              ),
            Image.asset('lib/assets/icons/LogoEmpresa.png', width: 200),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bem-vindo ao Dashboard!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: custom_Colors.colorScheme.onSurface),
            ),
            
          ],
        ),
      ),

      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,

        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductRegistration(),
              ),
            );
          }

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StandInPage(),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StandInPage(),
              ),
            );
          }

          if (index == 3) {
            
          }

          
        },
      ),
    );
  }
}