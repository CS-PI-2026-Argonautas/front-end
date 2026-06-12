import "package:flutter/material.dart";

class PasswordSetting extends StatefulWidget{

  const PasswordSetting({super.key});

  @override
  State<PasswordSetting> createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSetting>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Defina sua senha',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              child: _TipText(),
            ),
            SizedBox(),

            
            SizedBox(),
            SizedBox(),
            SizedBox(),
            SizedBox(),
            SizedBox(),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}

class _TipText extends StatelessWidget{

  String tipText = 'Dica: use frases-passe ao invés de senhas padrões para criar credenciais mais longas, seguras e fáceis de memorizar.';
  String exampleText = 'Exemplo: cachorro#morde#pelucia@23';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(tipText),
        SizedBox(height: 10,),
        Text(exampleText),
      ],
    );
  }
}