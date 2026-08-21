import 'package:flutter/material.dart';
import 'package:frontend/pages/os/tabs/values_os.dart';
import 'package:frontend/pages/os/tolls_os.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class Tabbar extends StatefulWidget {
  final serviceOrderNumber;

  const Tabbar({super.key, required this.serviceOrderNumber});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with TickerProviderStateMixin {
  late final TabController _tabController;

  final colors = custom_colors.colorScheme;

  void goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void goToPreviousTab() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OS nº ${widget.serviceOrderNumber}'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onSecondary,
        leading: _onBackAppbar,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.onSecondary,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.description), text: 'Dados'),
            Tab(icon: Icon(Icons.build), text: 'Peças'),
            Tab(icon: Icon(Icons.handyman), text: 'Serviços'),
            Tab(icon: Icon(Icons.attach_money), text: 'Valores'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    goToNextTab();
                  },
                  child: Text('avançar'),
                ),
              ],
            ),
          ),
          TollsOs(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('aqui serao os servicos'),
                ElevatedButton(
                  onPressed: () {
                    goToNextTab();
                  },
                  child: Text('avançar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    goToPreviousTab();
                  },
                  child: Text('voltar'),
                ),
              ],
            ),
          ),
          ValuesOs(),
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Text('aqui serao os valores'),
          //       ElevatedButton(
          //         onPressed: () {
          //           goToNextTab();
          //         },
          //         child: Text('avançar'),
          //       ),
          //       ElevatedButton(
          //         onPressed: () {
          //           goToPreviousTab();
          //         },
          //         child: Text('voltar'),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget get _onBackAppbar {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
      ),
    );
  }
}
