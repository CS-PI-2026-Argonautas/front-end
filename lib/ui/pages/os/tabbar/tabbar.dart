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

  final OsValoresController _valores = OsValoresController();

  bool _dadosObrigatoriosPreenchidos = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _valores.dispose();
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

  /// Sem número real a OS é nova (null, vazio ou -1).
  String get _titulo {
    final numero = widget.serviceOrderNumber?.toString().trim() ?? '';
    return (numero.isEmpty || numero == '-1') ? 'Nova OS' : 'OS nº $numero';
  }

  void _irParaAba(int index) => _tabController.animateTo(index);

  bool get _temDados =>
      _dadosObrigatoriosPreenchidos || _valores.quantidadeItens > 0;

  /// Nada nesta tela é gravado ainda; avisa antes de descartar o que foi
  /// preenchido (voltar pela seta ou pelo gesto/botão do sistema).
  Future<void> _tentarSair() async {
    if (!_temDados) {
      Navigator.pop(context);
      return;
    }

    final sair =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Sair da OS?'),
            content: const Text(
              'Os dados desta OS ainda não foram salvos e serão perdidos.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('CONTINUAR EDITANDO'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text('SAIR', style: TextStyle(color: colors.error)),
              ),
            ],
          ),
        ) ??
        false;

    if (sair && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _tentarSair();
      },
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
          onPressed: _tentarSair,
        ),

        title: Text(
          _titulo,
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
            avancarTab: () => _irParaAba(1),
          ),

          TollsOs(
            onItensChanged: _valores.definirPecas,
            onAvancar: () => _irParaAba(2),
          ),

          OsServicosTab(
            onItensChanged: _valores.definirServicos,
            onAvancar: () => _irParaAba(3),
          ),

          ValuesOs(
            valores: _valores,
            concluida: _status == 'CONCLUIDA',
            onConcluir: _concluirOs,
          ),
        ],
      ),
    ),
    );
  }
}