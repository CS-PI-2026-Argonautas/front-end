import 'package:flutter/material.dart';
import 'package:frontend/widgets/header.dart';

class Tabbar extends StatefulWidget{

  final serviceOrderNumber;

  const Tabbar({super.key, required this.serviceOrderNumber});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(onBack: () =>  Navigator.pop(context), title: Text('OS nº ${widget.serviceOrderNumber}')),
      );
  }
}