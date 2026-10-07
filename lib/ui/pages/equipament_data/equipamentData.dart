import 'package:flutter/material.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;

class EquipamentData extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final void Function(Map<String, String> dadosBalanca)? onSubmit;

  const EquipamentData({super.key, this.onBack, this.onClose, this.onSubmit});

  @override
  State<EquipamentData> createState() => _EquipamentDataState();
}

class _EquipamentDataState extends State<EquipamentData> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _numeroSerieController = TextEditingController();
  final TextEditingController _portariaController = TextEditingController();
  final TextEditingController _numeroInmetroController =
      TextEditingController();
  final TextEditingController _numeroVerificacaoController =
      TextEditingController();
  final TextEditingController _seloAnteriorController = TextEditingController();
  final TextEditingController _seloAtualController = TextEditingController();
  final TextEditingController _lacreAnteriorController =
      TextEditingController();
  final TextEditingController _lacreAtualController = TextEditingController();

  static const Color _inputFillColor = Color(0xFFF3F6F8);
  static const Color _inputBorderColor = Color(0xFFD3DFE7);
  static const Color _labelTextColor = Color(0xFF263944);
  static const Color _iconBlueColor = Color(0xFF2A92B6);

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _numeroSerieController.dispose();
    _portariaController.dispose();
    _numeroInmetroController.dispose();
    _numeroVerificacaoController.dispose();
    _seloAnteriorController.dispose();
    _seloAtualController.dispose();
    _lacreAnteriorController.dispose();
    _lacreAtualController.dispose();
    super.dispose();
  }

  void _handleCadastrar() {
    if (_formKey.currentState?.validate() ?? true) {
      final dados = {
        'marca': _marcaController.text.trim(),
        'modelo': _modeloController.text.trim(),
        'numeroSerie': _numeroSerieController.text.trim(),
        'portaria': _portariaController.text.trim(),
        'numeroInmetro': _numeroInmetroController.text.trim(),
        'numeroVerificacao': _numeroVerificacaoController.text.trim(),
        'seloAnterior': _seloAnteriorController.text.trim(),
        'seloAtual': _seloAtualController.text.trim(),
        'lacreAnterior': _lacreAnteriorController.text.trim(),
        'lacreAtual': _lacreAtualController.text.trim(),
      };

      if (widget.onSubmit != null) {
        widget.onSubmit!(dados);
      } else {
        Navigator.maybePop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
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
          'Balança',
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                        'Dados do Equipamento',
                        style: TextStyle(
                          color: _labelTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Preencha as informações técnicas da balança.',
                        style: TextStyle(
                          color: _labelTextColor.withOpacity(0.65),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 22),

                      _buildField(
                        label: 'Marca',
                        icon: Icons.branding_watermark_outlined,
                        controller: _marcaController,
                        colors: colors,
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        label: 'Modelo',
                        icon: Icons.devices_other_outlined,
                        controller: _modeloController,
                        colors: colors,
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        label: 'Nº de Série',
                        icon: Icons.pin_outlined,
                        controller: _numeroSerieController,
                        colors: colors,
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        label: 'Portaria',
                        icon: Icons.assignment_outlined,
                        controller: _portariaController,
                        colors: colors,
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        label: 'Nº do Inmetro',
                        icon: Icons.verified_outlined,
                        controller: _numeroInmetroController,
                        colors: colors,
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        label: 'Nº de Verificação',
                        icon: Icons.fact_check_outlined,
                        controller: _numeroVerificacaoController,
                        colors: colors,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              label: 'Selo anterior',
                              icon: Icons.security_outlined,
                              controller: _seloAnteriorController,
                              colors: colors,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildField(
                              label: 'Selo atual',
                              icon: Icons.verified_user_outlined,
                              controller: _seloAtualController,
                              colors: colors,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              label: 'Lacre anterior',
                              icon: Icons.lock_clock_outlined,
                              controller: _lacreAnteriorController,
                              colors: colors,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildField(
                              label: 'Lacre atual',
                              icon: Icons.lock_outline,
                              controller: _lacreAtualController,
                              colors: colors,
                            ),
                          ),
                        ],
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
                          widget.onBack ?? () => Navigator.maybePop(context),
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
                        'Voltar',
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
    required IconData icon,
    required TextEditingController controller,
    required ColorScheme colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: _iconBlueColor),
            const SizedBox(width: 6),
            Text(
              label,
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
          style: const TextStyle(
            color: _labelTextColor,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: _inputFillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
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
