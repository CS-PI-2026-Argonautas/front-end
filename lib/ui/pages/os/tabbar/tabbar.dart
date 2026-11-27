import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/fire_base/Enums/StatusOrderService.dart';
import 'package:frontend/fire_base/repositories/os_repository.dart';
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
  final colors = custom_colors.colorScheme;

  final OsRepository _osRepository = FirestoreOsRepository();

  late final TabController _tabController;
  late final ServiceOrder _serviceOrder;

  bool _dadosObrigatoriosPreenchidos = false;
  bool _salvando = false;
  bool _somenteServicos = false;

  @override
  void initState() {
    super.initState();

    _serviceOrder = ServiceOrder.createNew();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Salva a OS sem alterar o status.
  Future<void> _salvarOs() async {
    if (_salvando) return;

    setState(() {
      _salvando = true;
    });

    try {
      await _osRepository.salvar(_serviceOrder);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ordem de serviço salva com sucesso!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  // Conclui a OS, salva e retorna somente se tudo der certo.
  Future<void> _concluirOs() async {
    if (_salvando) return;

    if (!_dadosObrigatoriosPreenchidos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione um cliente, um endereço e um equipamento antes de concluir.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      _tabController.animateTo(0);
      return;
    }

    final statusAnterior = _serviceOrder.status;

    setState(() {
      _salvando = true;
    });

    try {
      _serviceOrder.changeStatus(ServiceOrderStatus.CONCLUIDA);

      await _osRepository.salvar(_serviceOrder);

      if (!mounted) return;

      Navigator.pop(context, _serviceOrder);
    } catch (e) {
      // Se falhar, restaura o status anterior.
      _serviceOrder.changeStatus(statusAnterior);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível concluir a OS: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  void _atualizarDadosObrigatorios(bool preenchidos) {
    if (_dadosObrigatoriosPreenchidos == preenchidos) {
      return;
    }

    setState(() {
      _dadosObrigatoriosPreenchidos = preenchidos;
    });
  }

  void _notificarAlteracaoOS() {
    if (!mounted) return;

    setState(() {});
  }

  bool _podeAcessarAba(int index) {
    switch (index) {
      case 0:
        return true;

      case 1:
        return _dadosObrigatoriosPreenchidos;

      case 2:
        return _dadosObrigatoriosPreenchidos &&
            (_serviceOrder.parts.isNotEmpty || _somenteServicos);

      case 3:
        return _dadosObrigatoriosPreenchidos &&
            (_somenteServicos || _serviceOrder.services.isNotEmpty) &&
            (_serviceOrder.parts.isNotEmpty || _somenteServicos);

      default:
        return false;
    }
  }

  void _atualizarSomenteServicos(bool valor) {
    setState(() {
      _somenteServicos = valor;
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
          onPressed: _salvando ? null : () => Navigator.pop(context),
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
            if (!_podeAcessarAba(index)) {
              _tabController.animateTo(_tabController.previousIndex);

              String mensagem;

              if (!_dadosObrigatoriosPreenchidos) {
                mensagem =
                    'Selecione um cliente, um endereço e um equipamento antes de concluir.';
              } else if (_serviceOrder.parts.isEmpty && index >= 2) {
                mensagem =
                    'Adicione pelo menos uma peça ou marque a caixa de selecao antes de continuar.';
              } else {
                mensagem = 'Adicione pelo menos um serviço antes de continuar.';
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(mensagem),
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
        physics:
            _dadosObrigatoriosPreenchidos &&
                (_serviceOrder.parts.isNotEmpty || _somenteServicos) &&
                _serviceOrder.services.isNotEmpty
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),

        children: [
          DataOs(
            serviceOrder: _serviceOrder,
            avancarTab: () {
              _tabController.animateTo(1);
            },
            onDadosObrigatoriosChanged: _atualizarDadosObrigatorios,
            onChanged: _notificarAlteracaoOS,
          ),

          TollsOs(
            serviceOrder: _serviceOrder,
            avancarTab: () {
              _tabController.animateTo(2);
            },
            onChanged: _notificarAlteracaoOS,
            onSomenteServicosChanged: _atualizarSomenteServicos,
          ),

          OsServicosTab(
            serviceOrder: _serviceOrder,
            avancarTab: () {
              _tabController.animateTo(3);
            },
            onChanged: _notificarAlteracaoOS,
          ),

          ValuesOs(
            serviceOrder: _serviceOrder,
            onConcluir: _concluirOs,
            onChanged: _notificarAlteracaoOS,
          ),
        ],
      ),
    );
  }
}
