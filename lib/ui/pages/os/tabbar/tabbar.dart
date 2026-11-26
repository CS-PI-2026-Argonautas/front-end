import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/fire_base/Enums/StatusOrderService.dart';
import 'package:frontend/fire_base/repositories/os_repository.dart';
import 'package:frontend/ui/pages/os/service_order_state.dart';
import 'package:frontend/ui/pages/os/tabs/data_os.dart';
import 'package:frontend/ui/pages/os/tabs/os_service.dart';
import 'package:frontend/ui/pages/os/tabs/values_os.dart';
import 'package:frontend/ui/pages/os/tabs/tolls_os.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;

class Tabbar extends StatefulWidget {
  final dynamic serviceOrderNumber;

  final String? serviceOrderId;

  const Tabbar({
    super.key,
    required this.serviceOrderNumber,
    this.serviceOrderId,
  });

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with SingleTickerProviderStateMixin {
  final colors = custom_colors.colorScheme;

  final OsRepository _osRepository = FirestoreOsRepository();

  late final TabController _tabController;
  late ServiceOrderState _serviceOrderState;

  ServiceOrder get _serviceOrder => _serviceOrderState.serviceOrder;

  bool _dadosObrigatoriosPreenchidos = false;
  bool _salvando = false;

  bool get _modoEdicao => widget.serviceOrderId != null;
  bool _carregando = false;
  String? _erroCarregamento;

  @override
  void initState() {
    super.initState();

    _serviceOrderState = ServiceOrderState(
      ServiceOrder.createNew(),
      saveDraft: _osRepository.salvarRascunho,
    );

    _tabController = TabController(length: 4, vsync: this);

    if (_modoEdicao) {
      _carregarOs();
    }
  }

  Future<void> _carregarOs() async {
    setState(() {
      _carregando = true;
      _erroCarregamento = null;
    });

    try {
      final os = await _osRepository.buscarPorId(widget.serviceOrderId!);

      if (!mounted) return;

      if (os == null) {
        setState(() {
          _erroCarregamento = 'Ordem de serviço não encontrada.';
          _carregando = false;
        });
        return;
      }

      setState(() {
        _serviceOrderState.dispose();
        _serviceOrderState = ServiceOrderState(
          os,
          saveDraft: _osRepository.salvarRascunho,
        );
        _dadosObrigatoriosPreenchidos =
            os.client != null && os.serviceAddress != null;
        _carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar OS: $e');

      if (!mounted) return;

      setState(() {
        _erroCarregamento = 'Não foi possível carregar a ordem de serviço.';
        _carregando = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _serviceOrderState.dispose();
    super.dispose();
  }

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

  Future<void> _concluirOs() async {
    if (_salvando) return;

    if (!_dadosObrigatoriosPreenchidos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione um cliente e um endereço antes de concluir.',
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
      if (!_modoEdicao) {
        _serviceOrder.changeStatus(ServiceOrderStatus.CONCLUIDA);
      }

      await _osRepository.salvar(_serviceOrder);

      if (!mounted) return;

      Navigator.pop(context, _serviceOrder);
    } catch (e) {
      if (!_modoEdicao) {
        _serviceOrder.changeStatus(statusAnterior);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível salvar a OS: '
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

  @override
  Widget build(BuildContext context) {
    if (_carregando || _erroCarregamento != null) {
      return Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(title: Text('OS nº ${widget.serviceOrderNumber}')),
        body: Center(
          child: _carregando
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_erroCarregamento!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _carregarOs,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
        ),
      );
    }

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
          'OS nº ${_serviceOrder.numeroOs ?? widget.serviceOrderNumber}',
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
                    'Selecione um cliente e um endereço antes de continuar.',
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
        key: ValueKey(_serviceOrder),
        controller: _tabController,
        physics: _dadosObrigatoriosPreenchidos
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),

        children: [
          DataOs(
            serviceOrder: _serviceOrder,
            avancarTab: () {
              _tabController.animateTo(1);
            },
            onDadosObrigatoriosChanged: _atualizarDadosObrigatorios,
            onChanged: () {
              setState(() {});
            },
          ),

          TollsOs(serviceOrder: _serviceOrder),

          OsServicosTab(serviceOrder: _serviceOrder),

          ValuesOs(serviceOrder: _serviceOrder, onConcluir: _concluirOs),
        ],
      ),
    );
  }
}
