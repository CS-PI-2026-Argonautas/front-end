import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonRegistration3 extends StatefulWidget {
  const PersonRegistration3({super.key});

  @override
  State<PersonRegistration3> createState() => _PersonRegistration3State();
}

class _PersonRegistration3State extends State<PersonRegistration3> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  final _phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

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
                  _buildHeader(),
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

  // Cabeçalho baseado no ProductHeader[cite: 14]
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
                child: Icon(Icons.contact_mail_outlined, color: colors.primary, size: 30),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text('Contato',
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
          const Text('Finalize o cadastro informando os meios de comunicação e observações gerais.',
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }

  // Card do formulário baseado no ProductForm
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
              _buildSectionTitle("Canais de Comunicação", "Informe pelo menos um contato principal."),
              const SizedBox(height: 30),

              _buildFieldLabel(Icons.phone_outlined, "Telefone principal *"),
              const SizedBox(height: 10),
              TextFormField(
                decoration: customInputDecoration(hintText: "(44) 98765-4321"),
                inputFormatters: [_phoneFormatter],
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o telefone';
                  if (value.length < 15) return 'Telefone incompleto';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildFieldLabel(Icons.email_outlined, "Email *"),
              const SizedBox(height: 10),
              TextFormField(
                decoration: customInputDecoration(hintText: "exemplo@email.com"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o email';
                  final bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if (!emailValid) return 'Informe um email válido';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildFieldLabel(Icons.contact_phone_outlined, "Contato adicional"),
              const SizedBox(height: 10),
              TextFormField(
                decoration: customInputDecoration(hintText: "Nome ou telefone extra"),
                maxLength: 50,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
              ),

              const SizedBox(height: 20),

              _buildFieldLabel(Icons.comment_outlined, "Observações"),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 4, // Estilo multiline igual ao de Produtos[cite: 13]
                maxLength: 255,
                keyboardType: TextInputType.multiline,
                decoration: customInputDecoration(hintText: "Digite observações relevantes aqui..."),
              ),

              const SizedBox(height: 30),

           
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
      if (_formKey.currentState!.validate()) {
      
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
          (route) => false, // Limpa a pilha de navegação[cite: 18]
        );
      }
    },
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Cadastrar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.onSurface,
                        side: BorderSide(color: colors.surfaceContainerHigh),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.close),
                      label: const Text("Cancelar"),
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