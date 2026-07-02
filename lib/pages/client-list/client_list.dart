import 'package:flutter/material.dart';
import 'package:frontend/models/cliente.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/pages/edit_item/item_edition.dart';
import 'package:frontend/pages/product_registration/product_registration.dart';
import 'package:frontend/pages/stand_in_page.dart';
import 'package:frontend/repositories/mock_client_repository.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/widgets/menu.dart';
class ClientList extends StatefulWidget {
  const ClientList({super.key});

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final MockClientRepository _repository = MockClientRepository();
  late Future<List<Cliente>> _futureClientes;
  final colors = custom_colors.colorScheme;

  @override
  void initState() {
    super.initState();
    _futureClientes = _repository.listarTodos();
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
        'Listar Clientes',
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
              MaterialPageRoute(builder: (context) => const ItemEdition()),
            );
          }
          if(index == 4){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          }
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Procurar cliente',
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: colors.onSurface),
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
                          backgroundColor: Colors.blue,
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
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                //aqui faço meu "for" e adiciono um
                FutureBuilder<List<Cliente>>(
                  future: _futureClientes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Erro ao carregar clientes.'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Nenhum cliente encontrado.'),
                      );
                    }

                    final clientes = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: clientes.length,
                      itemBuilder: (context, index) {
                        return _buildClientCard(clientes[index]);
                      },
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

  // construo meus cards
  Widget _buildClientCard(Cliente cliente) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        border: Border.all(color: colors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cliente.nome,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cliente.endereco,
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            cliente.info_contato,
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
