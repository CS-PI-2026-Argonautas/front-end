import 'package:flutter/material.dart';
import 'package:frontend/pages/person_registration/person_registration.dart';
import 'package:frontend/pages/person_registration/person_registration_contact.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/widgets/action_buttons.dart';
import 'package:frontend/widgets/header.dart';

class PersonRegistrationAddress extends StatefulWidget {
  const PersonRegistrationAddress({super.key});

  @override
  State<PersonRegistrationAddress> createState() => _PersonRegistration2State();
}

class _PersonRegistration2State extends State<PersonRegistrationAddress> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _numeroController = TextEditingController();
  final _ufController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: Header(
        onBack: () { Navigator.pop(context);}, 
        title: 'Endereço',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildFormCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Cabeçalho estilizado baseado no ProductHeader[cite: 14]
 

  Widget _buildFormCard() {
    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                "Localização",
                "Campos obrigatórios estão marcados com *",
              ),
              const SizedBox(height: 30),

              _buildFieldLabel(Icons.pin_drop_outlined, "CEP"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cepController,
                decoration: customInputDecoration(hintText: "12312312"),
              ),

              const SizedBox(height: 20),

              _buildFieldLabel(Icons.home_outlined, "Rua"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ruaController,
                decoration: customInputDecoration(hintText: "Rua exemplo"),
              ),

              const SizedBox(height: 20),

              _buildFieldLabel(Icons.location_city, "Cidade *"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cidadeController,
                decoration: customInputDecoration(
                  hintText: "Informe sua cidade",
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Informe a cidade'
                    : null,
              ),

              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(Icons.numbers, "Número"),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _numeroController,
                          keyboardType: TextInputType.text,
                          decoration: customInputDecoration(
                            hintText: "Ex: 123A",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(Icons.flag_outlined, "UF *"),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _ufController,
                          decoration: customInputDecoration(hintText: "PR"),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Informe a UF'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Botões de ação
              ActionButtons(
                formKey: _formKey,
                colors: colors,
                onCancel: () {
                  Navigator.pop(context);
                },
                onCadastrar: () {
                  String rua = _ruaController.text.trim();
                  String cidade = _cidadeController.text.trim();
                  String uf = _ufController.text.trim().toUpperCase();
                  String numero = _numeroController.text.trim();
                  String enderecoFormatado = "$cidade - $uf, $rua";

                  if (numero.isNotEmpty) {
                    enderecoFormatado += ", $numero";
                  }

                  Navigator.pop(context, enderecoFormatado);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}
