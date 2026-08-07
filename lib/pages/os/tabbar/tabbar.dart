import 'package:flutter/material.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class Tabbar extends StatefulWidget{

  final serviceOrderNumber;

  const Tabbar({super.key, required this.serviceOrderNumber});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with TickerProviderStateMixin{

  late final TabController _tabController;

  final colors = custom_colors.colorScheme;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, 
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: colors.surface,
          title: Text('OS nº ${widget.serviceOrderNumber}'),
          bottom: TabBar(
            tabs: <Widget> [
              Tab(icon: Icon(Icons.description), text: 'Dados',),
              Tab(icon: Icon(Icons.build), text: 'Peças',),
              Tab(icon: Icon(Icons.handyman), text: 'Serviços',),
              Tab(icon: Icon(Icons.attach_money), text: 'Valores',),
            ]
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(child: Text('aqui serao os dados'),),
            Center(child: Text('aqui serao as peças'),),
            Center(child: Text('aqui serao os servicos'),),
            Center(child: Text('aqui serao os valores'),),
          ]),
      ),
    );
  }
}