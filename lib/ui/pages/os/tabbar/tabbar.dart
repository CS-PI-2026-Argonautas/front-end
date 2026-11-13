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

class _TabbarState extends State<Tabbar> with SingleTickerProviderStateMixin {
  String _status = 'EM_CONSERTO';

  final colors = custom_colors.colorScheme;

  late TabController _tabController;

  bool _dadosObrigatoriosPreenchidos = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  void _atualizarDadosObrigatorios(bool preenchidos) {
    setState(() {
      _dadosObrigatoriosPreenchidos = preenchidos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              colors: [colors.primary, colors.tertiary],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,

          onTap: (index) {
            if (index != 0 && !_dadosObrigatoriosPreenchidos) {
              _tabController.animateTo(0);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Cadastre um cliente, endereço e equipamento antes de continuar.',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },

          tabs: const [
            Tab(icon: Icon(Icons.description), text: 'Dados'),
            Tab(icon: Icon(Icons.build), text: 'Peças'),
            Tab(icon: Icon(Icons.handyman), text: 'Serviços'),
            Tab(icon: Icon(Icons.attach_money), text: 'Valores'),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,

        physics: _dadosObrigatoriosPreenchidos
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),

        children: [
          DataOs(
            status: _status,
            onStatusChanged: _alterarStatus,
            onDadosObrigatoriosChanged: _atualizarDadosObrigatorios,
          ),

          TollsOs(),

          OsServicosTab(),

          ValuesOs(onConcluir: _concluirOs),
        ],
      ),
    );
  }
}
