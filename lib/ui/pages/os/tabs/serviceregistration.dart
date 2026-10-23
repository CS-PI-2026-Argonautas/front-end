import 'package:flutter/material.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';

class ServiceRegistration extends StatefulWidget {
  const ServiceRegistration({super.key});

  @override
  State<ServiceRegistration> createState() => _ServiceRegistrationState();
}

class _ServiceRegistrationState extends State<ServiceRegistration> {
  final colors = custom_colors.colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Serviços',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 18,
            children: [
              Text(
                'Nome do Serviço *',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colors.onSurface,
                ),
              ),
              TextFormField(
                decoration: customInputDecoration(hintText: 'Exemplo'),
              ),

              Text(
                'Descrição',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colors.onSurface,
                ),
              ),
              TextFormField(
                maxLines: 4,
                decoration: customInputDecoration(
                  hintText: 'Descreva o serviço (opcional)',
                ),
              ),

              Text(
                'Valor *',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colors.onSurface,
                ),
              ),
              TextFormField(
                decoration: customInputDecoration(hintText: '30.00'),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Cadastrar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
