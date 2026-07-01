import 'package:flutter/material.dart';
import 'package:frontend/models/cliente.dart';
import 'package:frontend/repositories/mock_client_repository.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/widgets/header.dart';

class ClientList extends StatefulWidget{
  const ClientList({super.key});
    
  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State <ClientList>{
  final MockClientRepository _repository = MockClientRepository();
  late Future <List<Cliente>> _futureClientes; 
  final colors = custom_colors.colorScheme;

  @override
  void initState  (){
    super.initState();
    _futureClientes = _repository.listarTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar : Header(
        onBack: () { Navigator.pop(context);},
        title: 'Listar Usuario'
      ),
      body: SafeArea(
          child: Center(
          child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
            
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Procurar cliente',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
        ),
      
          ),
          ),
          ),
      ),
    );
  }
}

