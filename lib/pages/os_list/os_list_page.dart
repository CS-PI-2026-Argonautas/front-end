import 'package:flutter/material.dart';
import 'package:frontend/models/os.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/pages/edit_item/item_edition.dart';
import 'package:frontend/pages/person_registration/person_registration.dart';
import 'package:frontend/pages/product_registration/product_registration.dart';
import 'package:frontend/pages/stand_in_page.dart';
import 'package:frontend/repositories/mock_os_repository.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/widgets/menu.dart';
import 'package:frontend/widgets/show_dialog/show_delete_os.dart';
import 'package:frontend/widgets/show_snackbar/show_delete_os.dart';
import 'package:frontend/widgets/slidable/slidable_delete_card.dart';

class OsListPage extends StatefulWidget {
  const OsListPage({super.key});

  @override
  State<OsListPage> createState() => _OsListPageState();
}

class _OsListPageState extends State<OsListPage> {
  final MockOsRepository _repository = MockOsRepository();
  
  late Future<List<OrdemServicos>> _futureOrdemServicos;

  final colors = custom_colors.colorScheme;

  @override
  void initState() {
    super.initState();
    _carregarOrdemServicos();
  }

  void _carregarOrdemServicos() {
    final Future<List<OrdemServicos>> os = _repository.listarTodos();

    setState(() {
      _futureOrdemServicos = os;
    });
  }

  Future<void> _deletarOrdemServicos(OrdemServicos os) async {
    os.removido = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,

      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        centerTitle: true,
        title: const Text(
          'Listar OS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      endDrawer: Menu(
        currentIndex: 0,
        onTap: (index) {
          Navigator.pop(context);

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductRegistration(),
              ),
            );
          }

          if (index == 0 || index == 2) {
            StandInPage();
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ItemEdition(),
              ),
            );
          }

          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
            );
          }
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 50,
            ),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Procurar OS',
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: colors.onSurface,
                    ),
                    prefixIcon: const Icon(Icons.search),
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
                        label: const Text('FILTRAR'),
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
                          label: const Text('ORDENAR'),
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
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                  ),
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

                // Aqui carrego as ordens de serviço
                FutureBuilder<List<OrdemServicos>>(
                  future: _futureOrdemServicos,
                  builder: (context, snapshot) {
                    if (
                        snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Erro ao carregar ordens de serviço.',
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhuma ordem de serviço encontrada.',
                        ),
                      );
                    }

                    final ordemServicos = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ordemServicos.length,
                      itemBuilder: (context, index) {
                        return _buildClientCard(
                          ordemServicos[index],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonRegistration(),
            ),
          );
        },
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Construo os cards
  Widget _buildClientCard(OrdemServicos os) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SlidableDeleteCard(
          slidableKey: ValueKey(os.id),

          onDelete: () async {
            final confimarExclusao =
                await showDialog(
                  context: context,
                  builder: (_) => ShowDeleteOsDialog(
                    nome: os.nome,
                  ),
                ) ??
                false;

            if (!confimarExclusao) return;

            await _deletarOrdemServicos(os);

            _carregarOrdemServicos();

            if (!mounted) return;

            final messenger = ScaffoldMessenger.of(context);

            messenger.hideCurrentSnackBar();

            messenger.showSnackBar(
              ShowDeleteOsSnackbar(
                color: colors.primary,
                onPressed: () {
                  os.removido = false;

                  _carregarOrdemServicos();

                  messenger.hideCurrentSnackBar();
                },
                duration: const Duration(seconds: 5),
              ),
            );
          },

          extentRatio: 0.20,

          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              border: Border.all(
                color: colors.primary,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        os.nome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Cliente: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: os.cliente),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Peça: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: os.peca),
                        ],
                      ),
                    ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: colors.primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const StandInPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}