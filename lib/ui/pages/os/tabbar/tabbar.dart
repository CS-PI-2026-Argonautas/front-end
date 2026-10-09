import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/os/tabs/data_os.dart';
import 'package:frontend/ui/pages/os/tabs/os_service.dart';
import 'package:frontend/ui/pages/os/tabs/values_os.dart';
import 'package:frontend/ui/pages/os/tabs/tolls_os.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;

class Tabbar extends StatefulWidget {
  final dynamic serviceOrderNumber;

  const Tabbar({super.key, required this.serviceOrderNumber});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with TickerProviderStateMixin {
  String _status = 'EM_CONSERTO';

  final colors = custom_colors.colorScheme;

  void _concluirOs() {
    setState(() {
      _status = 'CONCLUIDA';
    });
  }

  void _alterarStatus(String novoStatus) {
    setState(() {
      _status = novoStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'OS nº ${widget.serviceOrderNumber}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.tertiary,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(
                icon: Icon(Icons.description),
                text: 'Dados',
              ),
              Tab(
                icon: Icon(Icons.build),
                text: 'Peças',
              ),
              Tab(
                icon: Icon(Icons.handyman),
                text: 'Serviços',
              ),
              Tab(
                icon: Icon(Icons.attach_money),
                text: 'Valores',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DataOs(
              status: _status,
              onStatusChanged: _alterarStatus,
            ),
            TollsOs(),
            OsServicosTab(),
            ValuesOs(
              onConcluir: _concluirOs,
            ),
          ],
        ),
      ),
    );
  }
}