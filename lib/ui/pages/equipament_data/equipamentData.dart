import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/form/action_buttons.dart';
import 'package:frontend/ui/widgets/form/validator.dart';
import 'package:frontend/ui/widgets/form/form_card.dart';
import 'package:frontend/ui/widgets/form/labeled_form.dart';
import 'package:frontend/fire_base/models/equipamento.dart';
import 'package:frontend/fire_base/services/equipamento_service.dart';

class EquipamentData extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final VoidCallback? onCancel;
  final void Function(Map<String, String> dadosEquipamento)? onSubmit;

  final Map<String, dynamic>? osDados;

  const EquipamentData({
    super.key,
    this.onBack,
    this.onClose,
    this.onCancel,
    this.onSubmit,
    this.osDados,
  });

  @override
  State<EquipamentData> createState() => _EquipamentDataState();
}

class _EquipamentDataState extends State<EquipamentData> {
  static const _statusBloqueados = ['PAGA', 'ENTREGUE'];

  String? get _statusOs => widget.osDados?['status'] as String?;

  bool get _osBloqueada => _statusBloqueados.contains(_statusOs);

  String get _statusLabel => _statusOs == 'PAGA' ? 'paga' : 'entregue';

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

  bool _salvando = false;

  Future<void> _handleCadastrar() async {
    if (_osBloqueada) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não é possível cadastrar equipamento: a OS está $_statusLabel.',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _salvando = true);

    try {
      final equipamento = Equipamento(
        marca: _marcaController.text.trim(),
        modelo: _modeloController.text.trim(),
        numeroSerie: _numeroSerieController.text.trim(),
        portaria: _portariaController.text.trim(),
        numeroInmetro: _numeroInmetroController.text.trim(),
        numeroVerificacao: _numeroVerificacaoController.text.trim(),
        seloAnterior: _seloAnteriorController.text.trim(),
        seloAtual: _seloAtualController.text.trim(),
        lacreAnterior: _lacreAnteriorController.text.trim(),
        lacreAtual: _lacreAtualController.text.trim(),
      );

      final service = EquipamentoService();
      final idGerado = await service.salvar(equipamento);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Balança salva com sucesso!'),
          backgroundColor: const Color(0xFF1E9E5F),
          duration: const Duration(seconds: 3),
        ),
      );

      if (widget.onSubmit != null) {
        widget.onSubmit!({
          'id': idGerado,
          'marca': equipamento.marca,
          'modelo': equipamento.modelo,
        });
      } else {
        Navigator.maybePop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar no Firestore: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            'Adicionar Balança',
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
            child: FormCard(
              formKey: _formKey,
              title: 'Dados da Balança',
              subtitle: 'Preencha as informações técnicas da balança.',
              children: [
                _buildField(
                  label: 'Marca',
                  icon: Icons.branding_watermark_outlined,
                  controller: _marcaController,
                  hintText: 'Ex: Toledo',
                ),
                _buildField(
                  label: 'Modelo',
                  icon: Icons.devices_other_outlined,
                  controller: _modeloController,
                  hintText: 'Ex: Prix 3 Plus',
                ),
                _buildField(
                  label: 'Nº de Série',
                  icon: Icons.pin_outlined,
                  controller: _numeroSerieController,
                  isNumeric: true,
                ),
                _buildField(
                  label: 'Portaria',
                  icon: Icons.assignment_outlined,
                  controller: _portariaController,
                  isNumeric: true,
                ),
                _buildField(
                  label: 'Nº do Inmetro',
                  icon: Icons.verified_outlined,
                  controller: _numeroInmetroController,
                  isNumeric: true,
                ),
                _buildField(
                  label: 'Nº de Verificação',
                  icon: Icons.fact_check_outlined,
                  controller: _numeroVerificacaoController,
                  isNumeric: true,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: _buildField(
                        label: 'Selo anterior',
                        icon: Icons.security_outlined,
                        controller: _seloAnteriorController,
                        isNumeric: true,
                      ),
                    ),
                    Expanded(
                      child: _buildField(
                        label: 'Selo atual',
                        icon: Icons.verified_user_outlined,
                        controller: _seloAtualController,
                        isNumeric: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: _buildField(
                        label: 'Lacre anterior',
                        icon: Icons.lock_clock_outlined,
                        controller: _lacreAnteriorController,
                        isNumeric: true,
                      ),
                    ),
                    Expanded(
                      child: _buildField(
                        label: 'Lacre atual',
                        icon: Icons.lock_outline,
                        controller: _lacreAtualController,
                        isNumeric: true,
                      ),
                    ),
                  ],
                ),
                ActionButtons(
                  formKey: _formKey,
                  colors: colors,
                  onCadastrar: () {
                    if (_salvando) return;
                    _handleCadastrar();
                  },
                  onCancel:
                      widget.onCancel ??
                      widget.onBack ??
                      () => Navigator.maybePop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? hintText,
    bool isNumeric = false,
  }) {
    return LabeledFormField(
      icon: icon,
      label: label,
      field: TextFormField(
        controller: controller,
        validator: requiredValidator,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumeric
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: customInputDecoration(hintText: hintText),
      ),
    );
  }
}
