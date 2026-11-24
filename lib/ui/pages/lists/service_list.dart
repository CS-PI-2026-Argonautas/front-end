import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/fire_base/models/service.dart';
import 'package:frontend/fire_base/services/service_service.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/lists/client_list.dart';
import 'package:frontend/ui/pages/lists/os_list_page.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/pages/service_registration/service_registration.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/floatingButton.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/menu.dart';
import 'package:frontend/ui/widgets/slidable/slidable_delete_card.dart';

class ServiceList extends StatefulWidget {
  const ServiceList({super.key});

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  final ServiceService _service = ServiceService();

  late final Stream<List<Service>> _servicos = _service.watchServices();

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  final colors = custom_colors.colorScheme;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatarValor(int centavos) {
    return Dinheiro(centavos).formatado().replaceAll(RegExp(r'[\s\u00A0]'), '');
  }

  Future<void> _deletarServico(Service servico) async {
    final id = servico.id;

    if (id == null || id.isEmpty) {
      throw StateError('Serviço sem identificador.');
    }

    await _service.delete(id);
  }

  Future<void> _restaurarServico(Service servico) async {
    final id = servico.id;

    if (id == null || id.isEmpty) {
      throw StateError('Serviço sem identificador.');
    }

    await _service.restore(id);
  }

  Future<void> _abrirCadastro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ServiceRegistration()),
    );
  }

  Future<void> _abrirEdicao(Service servico) async {
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => ServiceRegistration(initialService: servico),
    //   ),
    // );
  }

  Future<void> _confirmarRemocao(Service servico) async {
    final confirmar =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Remover serviço'),
            content: Text('Deseja remover "${servico.name}" do catálogo?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text(
                  'Remover',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmar || !mounted) return;

    try {
      await _deletarServico(servico);

      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          backgroundColor: colors.primary,
          content: Row(
            children: [
              Expanded(
                child: Text(
                  'Serviço ${servico.name} foi removido com sucesso!',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                tooltip: 'Fechar',
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'DESFAZER',
            textColor: Colors.white,
            onPressed: () async {
              try {
                await _restaurarServico(servico);
              } catch (e) {
                debugPrint('Erro ao restaurar serviço: $e');

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Não foi possível restaurar o serviço.'),
                  ),
                );
              }
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint('Erro ao remover serviço: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível remover o serviço.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,

      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Listagem de serviços',
      ),

      endDrawer: Menu(
        currentIndex: 3,
        onTap: (index) {
          Navigator.pop(context);

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClientList()),
            );
          }

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductRegistration()),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OsListPage()),
            );
          }

          if (index == 3) {
            // Já estamos na listagem de serviços.
          }

          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Dashboard()),
            );
          }
        },
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Procurar serviço',
                      filled: true,
                      fillColor: colors.surfaceContainer,
                      hintStyle: TextStyle(color: colors.onSurface),
                      prefixIcon: Icon(Icons.search, color: colors.secondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: colors.secondary),
                              onPressed: _searchController.clear,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.tune),
                          label: const Text(
                            'Filtrar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.8,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.swap_vert),
                            label: const Text(
                              'Ordenar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.8,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recentes',
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  StreamBuilder<List<Service>>(
                    stream: _servicos,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar serviços.'),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Nenhum serviço encontrado.'),
                        );
                      }

                      final todosServicos = snapshot.data!;

                      final servicosFiltrados = todosServicos.where((servico) {
                        return servico.name.toLowerCase().contains(
                          _searchQuery,
                        );
                      }).toList();

                      if (servicosFiltrados.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: Text(
                              'Nenhum serviço corresponde à pesquisa.',
                              style: TextStyle(color: colors.onSurfaceVariant),
                            ),
                          ),
                        );
                      }

                      return Card(
                        elevation: 4,
                        color: colors.surfaceContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: servicosFiltrados.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: colors.onSurfaceVariant.withOpacity(0.2),
                          ),
                          itemBuilder: (context, index) {
                            return _buildServiceCard(servicosFiltrados[index]);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton(onPressed: _abrirCadastro),
    );
  }

  Widget _buildServiceCard(Service servico) {
    return SlidableDeleteCard(
      slidableKey: ValueKey(servico.id),
      extentRatio: 0.20,
      onDelete: () => _confirmarRemocao(servico),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    servico.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatarValor(servico.valueInCents),
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: colors.secondary),
              onPressed: () => _abrirEdicao(servico),
            ),
          ],
        ),
      ),
    );
  }
}
