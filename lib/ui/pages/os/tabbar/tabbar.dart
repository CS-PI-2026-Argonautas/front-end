import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late final AppLifecycleListener _lifecycleListener;
  late ServiceOrderState _serviceOrderState;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _sincronizacaoSubscription;

  ServiceOrder get _serviceOrder => _serviceOrderState.serviceOrder;

  final OsValoresController _valores = OsValoresController();

  bool _dadosObrigatoriosPreenchidos = false;
  bool _salvando = false;
  bool _somenteServicos = false;
  bool _saindo = false;

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

    _observarSincronizacao();

    _tabController = TabController(length: 4, vsync: this);

    _lifecycleListener = AppLifecycleListener(
      onHide: () => unawaited(_serviceOrderState.flushPending()),
    );

    if (_modoEdicao) {
      _carregarOs();
    }
  }

  void _observarSincronizacao() {
    _sincronizacaoSubscription?.cancel();

    _sincronizacaoSubscription = _osRepository
        .observarSincronizacao(_serviceOrder.id)
        .listen(
          (snapshot) {
            if (!mounted) return;

            _serviceOrderState.updateSyncSnapshot(
              documentExists: snapshot.exists,
              hasPendingWrites: snapshot.metadata.hasPendingWrites,
            );
          },
          onError: (Object erro, StackTrace stackTrace) {
            debugPrint('Erro ao observar sincronização da OS: $erro');
            debugPrintStack(stackTrace: stackTrace);
          },
        );
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
            os.client != null &&
            os.serviceAddress != null &&
            os.equipment != null &&
            !os.equipment!.isEmpty;

        _somenteServicos = os.parts.isEmpty && os.services.isNotEmpty;

        _carregando = false;
      });

      _observarSincronizacao();
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
    _lifecycleListener.dispose();
    unawaited(_sincronizacaoSubscription?.cancel());
    unawaited(_serviceOrderState.flushPending());
    _tabController.dispose();
<<<<<<< HEAD
    _valores.dispose();
=======
    _serviceOrderState.dispose();
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
    super.dispose();
  }

  Future<void> _sair() async {
    if (_salvando || _saindo) return;

    setState(() => _saindo = true);

    final saved = await _serviceOrderState.flushPending();

    if (!mounted) return;

    if (saved && ModalRoute.of(context)?.isCurrent == true) {
      Navigator.pop(context);
      return;
    }

    setState(() => _saindo = false);

    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível salvar as alterações. Tente voltar novamente.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
    if (_salvando || _saindo) return;

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
      final savedLocally = await _serviceOrderState.beginCompletion();

      if (!mounted) return;

      if (!savedLocally) {
        throw Exception('Não foi possível gravar as alterações na fila local.');
      }

      if (_serviceOrder.status == ServiceOrderStatus.EM_ORCAMENTO ||
          _serviceOrder.status == ServiceOrderStatus.EM_CONSERTO) {
        _serviceOrder.changeStatus(ServiceOrderStatus.CONCLUIDA);
      }

      await _osRepository.salvar(_serviceOrder);
      _serviceOrderState.endCompletion(saved: true);

      if (!mounted) return;

      Navigator.pop(context, _serviceOrder);
    } catch (e) {
      _serviceOrder.changeStatus(statusAnterior);

      _serviceOrderState.endCompletion(saved: false);
      unawaited(_serviceOrderState.flushPending());

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

<<<<<<< HEAD
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
            title: const Text('Sair da ordem serviço?'),
            content: const Text(
              'Os dados desta ordem de serviço ainda não foram salvos e serão perdidos.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Continuar editando'),
                style: TextButton.styleFrom(
                  foregroundColor: colors.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Sair'),
                style: TextButton.styleFrom(
                  foregroundColor: colors.onError,
                  backgroundColor: colors.error,
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (sair && mounted) Navigator.pop(context);
=======
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

  IconData _iconeSincronizacao(ServiceOrderSyncStatus status) {
    switch (status) {
      case ServiceOrderSyncStatus.pending:
        return Icons.cloud_upload_outlined;
      case ServiceOrderSyncStatus.synced:
        return Icons.cloud_done_outlined;
      case ServiceOrderSyncStatus.failed:
        return Icons.cloud_off_outlined;
      case ServiceOrderSyncStatus.hidden:
        return Icons.cloud_outlined;
    }
  }

  Color _corSincronizacao(ServiceOrderSyncStatus status) {
    switch (status) {
      case ServiceOrderSyncStatus.pending:
        return Colors.amber;
      case ServiceOrderSyncStatus.synced:
        return Colors.greenAccent;
      case ServiceOrderSyncStatus.failed:
        return Colors.redAccent;
      case ServiceOrderSyncStatus.hidden:
        return Colors.white;
    }
  }

  void _mostrarEstadoSincronizacao() {
    final mensagem = _serviceOrderState.syncStatusLabel;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _tentarSair();
      },
      child: Scaffold(
=======
    return PopScope<ServiceOrder>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_sair());
      },
      child: AbsorbPointer(
        absorbing: _salvando || _saindo,
        child: _buildPage(),
      ),
    );
  }

  Widget _buildPage() {
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
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
<<<<<<< HEAD
          onPressed: _tentarSair,
=======
          onPressed: _salvando || _saindo ? null : _sair,
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
        ),
        title: Text(
<<<<<<< HEAD
          _titulo,
=======
          'OS nº ${_serviceOrder.numeroOs ?? widget.serviceOrderNumber}',
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: _serviceOrderState,
            builder: (context, child) {
              final status = _serviceOrderState.syncStatus;

              if (!_serviceOrderState.showSyncIndicator ||
                  status == ServiceOrderSyncStatus.hidden) {
                return const SizedBox.shrink();
              }

              return IconButton(
                tooltip: _serviceOrderState.syncStatusLabel,
                onPressed: _mostrarEstadoSincronizacao,
                icon: Icon(
                  _iconeSincronizacao(status),
                  color: _corSincronizacao(status),
                ),
              );
            },
          ),
        ],
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
        key: ValueKey(_serviceOrder),
        controller: _tabController,
        physics:
            _dadosObrigatoriosPreenchidos &&
                (_serviceOrder.parts.isNotEmpty || _somenteServicos) &&
                _serviceOrder.services.isNotEmpty
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: [
          DataOs(
            serviceOrderState: _serviceOrderState,
            avancarTab: () {
              _tabController.animateTo(1);
            },
            onDadosObrigatoriosChanged: _atualizarDadosObrigatorios,
<<<<<<< HEAD
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
=======
            onChanged: _notificarAlteracaoOS,
          ),

          TollsOs(
            serviceOrderState: _serviceOrderState,
            avancarTab: () {
              _tabController.animateTo(2);
            },
            onChanged: _notificarAlteracaoOS,
            onSomenteServicosChanged: _atualizarSomenteServicos,
          ),

          OsServicosTab(
            serviceOrderState: _serviceOrderState,
            avancarTab: () {
              _tabController.animateTo(3);
            },
            onChanged: _notificarAlteracaoOS,
          ),
          ValuesOs(
            serviceOrderState: _serviceOrderState,
            onConcluir: _concluirOs,
            onChanged: _notificarAlteracaoOS,
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
          ),
        ],
      ),
    ),
    );
  }
}