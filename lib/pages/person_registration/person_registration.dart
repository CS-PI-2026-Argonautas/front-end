import 'package:flutter/material.dart';
import 'package:frontend/pages/person_registration/person_registration_contact.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/pages/person_registration/person_registration_address.dart';
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/widgets/action_buttons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/widgets/header.dart' as header;

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
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _enderecoController = TextEditingController();
  final _contatoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: header.Header(
        onBack: () { Navigator.pop(context);}, 
        title: 'Cadastro de clientes',
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
                "Informações Pessoais",
                "Complete os campos de identificação abaixo.",
              ),
              const SizedBox(height: 30),

              _buildFieldLabel(Icons.person_outline, "Nome completo *"),
              const SizedBox(height: 10),
              TextFormField(
                decoration: customInputDecoration(
                  hintText: "Digite o nome aqui",
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Informe o nome' : null,
              ),

              const SizedBox(height: 25),

              //Endereço
              _buildFieldLabel(Icons.home_outlined, "Endereço"),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final resultadoEndereco = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonRegistrationAddress(),
                    ),
                  );

                  if (resultadoEndereco != null && mounted) {
                    setState(() {
                      _enderecoController.text = resultadoEndereco;
                    });
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration:
                      customInputDecoration(
                        hintText: "Inserir o endereço",
                      ).copyWith(
                        suffixIcon: Icon(
                          Icons.add_box_outlined,
                          color: colors.secondary,
                        ),
                      ),
                  isEmpty: _enderecoController.text.isEmpty,
                  child: Text(
                    _enderecoController.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: colors.onSurface),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              //Contato
              _buildFieldLabel(
                Icons.phone_android_outlined,
                "Informações de contato",
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final resultadoContato = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonRegistrationContact(),
                    ),
                  );

                  if (resultadoContato != null && mounted) {
                    setState(() {
                      _contatoController.text = resultadoContato;
                    });
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: customInputDecoration(hintText: "Inserir contato")
                      .copyWith(
                        suffixIcon: Icon(
                          Icons.add_box_outlined,
                          color: colors.secondary,
                        ),
                      ),
                  isEmpty: _contatoController.text.isEmpty,
                  child: Text(
                    _contatoController.text,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: colors.onSurface),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              _buildFieldLabel(
                Icons.badge_outlined,
                _isPessoaFisica ? "CPF *" : "CNPJ *",
              ),
              const SizedBox(height: 10),
              TextFormField(
                key: ValueKey(_isPessoaFisica),
                decoration: customInputDecoration(hintText: "000.000.000-00"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  _isPessoaFisica ? _cpfFormatter : _cnpjFormatter,
                ],
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Informe o documento'
                    : null,
              ),

              const SizedBox(height: 10),

              CheckboxListTile(
                value: _isPessoaFisica,
                onChanged: (value) =>
                    setState(() => _isPessoaFisica = value ?? false),
                activeColor: Colors.green,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  "Pessoa física?",
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Botões de ação
              ActionButtons(
                formKey: _formKey,
                colors: colors,
                onCancel: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                onCadastrar: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ),
                      (route) => false,
                    );
                  }
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
