import 'package:flutter/material.dart';
import 'package:frontend/models/cliente.dart';
import 'package:frontend/repositories/mock_client_repository.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/widgets/header.dart';

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
      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Listar Usuario',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
            // Substituímos o child direto por uma Column!
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
                  // Coloquei um padding aqui só para ele não ficar colado nos botões de cima
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Align(
                    alignment:
                        Alignment.centerLeft, // Empurra para a extrema esquerda
                    child: Text(
                      'Recentes',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 18, // Tamanho da fonte (opcional)
                        fontWeight: FontWeight
                            .bold, // Deixa o texto em negrito (opcional)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
