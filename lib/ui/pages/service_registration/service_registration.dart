import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;

class ServiceRegistration extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final VoidCallback? onCancel;
  final void Function(Map<String, String> dadosServico)? onSubmit;

  const ServiceRegistration({
    super.key,
    this.onBack,
    this.onClose,
    this.onCancel,
    this.onSubmit,
  });

  @override
  State<ServiceRegistration> createState() => _ServiceRegistrationState();
}

class _ServiceRegistrationState extends State<ServiceRegistration> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  static const Color _inputFillColor = Color(0xFFF3F6F8);
  static const Color _inputBorderColor = Color(0xFFD3DFE7);
  static const Color _labelTextColor = Color(0xFF263944);
  static const Color _iconBlueColor = Color(0xFF2A92B6);
  static const Color _requiredRedColor = Color(0xFFD32F2F);

  bool _salvando = false;
  bool _autovalidar = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _handleCadastrar() {
    // Ativa a validação em tempo real ao clicar no botão pela primeira vez
    setState(() => _autovalidar = true);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _salvando = true);

    try {
      final dados = {
        'nome': _nomeController.text.trim(),
        'descricao': _descricaoController.text.trim(),
        'valor': _valorController.text.trim(),
      };

      if (widget.onSubmit != null) {
        widget.onSubmit!(dados);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Serviço salvo com sucesso!'),
            backgroundColor: Color(0xFF1E9E5F),
          ),
        );
        Navigator.maybePop(context);
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: colors.surface,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.onPrimary,
        centerTitle: true,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.35),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Serviços',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 24),
            onPressed: widget.onClose ?? () => Navigator.maybePop(context),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.tertiary],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dados do Serviço',
                        style: TextStyle(
                          color: _labelTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Preencha as informações do serviço prestado.',
                        style: TextStyle(
                          color: _labelTextColor.withOpacity(0.65),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 22),

                      _buildField(
                        label: 'Nome do Serviço',
                        hintText: 'Ex: troca de bateria',
                        icon: Icons.work_outline,
                        controller: _nomeController,
                        colors: colors,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        label: 'Descrição',
                        hintText: 'Descricao do produto...', // Atualizado
                        icon: Icons.notes_outlined,
                        controller: _descricaoController,
                        colors: colors,
                        isRequired: false,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        label: 'Valor',
                        hintText: '40,00', // Atualizado
                        icon: Icons.attach_money,
                        controller: _valorController,
                        colors: colors,
                        isRequired: true,
                        isNumeric: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          widget.onCancel ?? () => Navigator.maybePop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: _inputBorderColor,
                          width: 1.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: _labelTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      // Botão simples, direto e sem firula (exatamente como no EquipamentData original)
                      onPressed: _handleCadastrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E9E5F),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildField({
    required String label,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    required ColorScheme colors,
    bool isRequired = false,
    bool isNumeric = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: _iconBlueColor),
            const SizedBox(width: 6),
            Text(
              isRequired ? '$label *' : label,
              style: const TextStyle(
                color: _labelTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          // Remove o erro instantaneamente assim que o utilizador começar a digitar
          autovalidateMode: _autovalidar
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          keyboardType: isNumeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
          inputFormatters: isNumeric
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\,?\d{0,2}'))]
              : null,
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                }
              : null,
          style: const TextStyle(
            color: _labelTextColor,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: _labelTextColor.withOpacity(0.4),
              fontSize: 14,
            ),
            isDense: true,
            filled: true,
            fillColor: _inputFillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            errorStyle: const TextStyle(
              color: _requiredRedColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: _inputBorderColor,
                width: 1.1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: _requiredRedColor,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: _requiredRedColor,
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: _inputBorderColor,
                width: 1.1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
