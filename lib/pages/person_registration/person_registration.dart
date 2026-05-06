import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/pages/person_registration/person_registration2.dart';
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonRegistration extends StatefulWidget {
  const PersonRegistration({super.key});

  @override
  State<PersonRegistration> createState() => _PersonRegistrationState1();
}

class _PersonRegistrationState1 extends State<PersonRegistration> {
  final _formKey = GlobalKey<FormState>();
  bool _isPessoaFisica = false;
  final colors = custom_colors.colorScheme;

  final _cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  final _cnpjFormatter = MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  _buildHeader(), // Cabeçalho estilizado (Estilo ProductHeader)
                  const SizedBox(height: 20),
                  _buildFormCard(), // Formulário dentro do Card (Estilo ProductForm)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Cabeçalho com Gradiente baseado no ProductHeader[cite: 14]
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.person_add_alt_1_outlined, color: colors.primary, size: 30),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text('Cadastro de Pessoa',
                    style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: colors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Preencha os dados de identificação para continuar o cadastro.',
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }

  // Card de Formulário baseado no ProductForm
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
              _buildSectionTitle("Informações Pessoais", "Complete os campos de identificação abaixo."),
              const SizedBox(height: 30),

              _buildFieldLabel(Icons.person_outline, "Nome completo *"),
              const SizedBox(height: 10),
              TextFormField(
                decoration: customInputDecoration(hintText: "Digite o nome aqui"),
                validator: (value) => (value == null || value.isEmpty) ? 'Informe o nome' : null,
              ),

              const SizedBox(height: 25),

              _buildFieldLabel(Icons.badge_outlined, _isPessoaFisica ? "CPF *" : "CNPJ *"),
              const SizedBox(height: 10),
              TextFormField(
                key: ValueKey(_isPessoaFisica),
               decoration: customInputDecoration(hintText: "000.000.000-00"),
                keyboardType: TextInputType.number,
                inputFormatters: [_isPessoaFisica ? _cpfFormatter : _cnpjFormatter],
                validator: (value) => (value == null || value.isEmpty) ? 'Informe o documento' : null,
              ),

              const SizedBox(height: 10),

              // Checkbox estilizado como o do ProductForm
              CheckboxListTile(
                value: _isPessoaFisica,
                onChanged: (value) => setState(() => _isPessoaFisica = value ?? false),
                activeColor: Colors.green,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("Pessoa física?", style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.w500)),
              ),

              const SizedBox(height: 30),

              // Botão Próximo (Estilo botão Salvar do ProductForm)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonRegistration2()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Próximo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
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
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.onSurface)),
        const SizedBox(height: 6),
        Text(subtitle, style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildFieldLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colors.onSurface)),
      ],
    );
  }
}