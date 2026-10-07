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
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
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
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Marca',
                  controller: _marcaController,
                  colors: colors,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Modelo',
                  controller: _modeloController,
                  colors: colors,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Nº de Série',
                  controller: _numeroSerieController,
                  colors: colors,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Portaria',
                  controller: _portariaController,
                  colors: colors,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Nº do Inmetro',
                  controller: _numeroInmetroController,
                  colors: colors,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Nº de Verificação',
                  controller: _numeroVerificacaoController,
                  colors: colors,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Selo anterior',
                        controller: _seloAnteriorController,
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Selo atual',
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
                      child: _buildTextField(
                        label: 'Lacre anterior',
                        controller: _lacreAnteriorController,
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Lacre atual',
                        controller: _lacreAtualController,
                        colors: colors,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            widget.onBack ?? () => Navigator.maybePop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: colors.outline.withOpacity(0.4),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Voltar',
                          style: TextStyle(
                            color: colors.onSurface,
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
                            borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ColorScheme colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: colors.onSurface, fontSize: 15),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.outline.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.outline.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.primary, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
