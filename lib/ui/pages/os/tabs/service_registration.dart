import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/form/action_buttons.dart';
import 'package:frontend/ui/widgets/form/validator.dart';
import 'package:frontend/ui/widgets/form/form_card.dart';
import 'package:frontend/ui/widgets/form/labeled_form.dart';
import 'package:frontend/fire_base/services/servicoService.dart';
import 'package:frontend/fire_base/models/servico.dart';

class ServiceRegistration extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final VoidCallback? onCancel;
  final void Function(Map<String, dynamic> dadosServico)? onSubmit;

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

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  int _converterParaCentavos(String valorTexto) {
    if (valorTexto.isEmpty) return 0;
    String valorFormatado = valorTexto.replaceAll(',', '.');
    double valorDouble = double.tryParse(valorFormatado) ?? 0.0;
    return (valorDouble * 100).round();
  }

  void _handleCadastrar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final servicoService = ServicoService();
    final novoServico = Servico(
      nome: _nomeController.text.trim(),
      descricao: _descricaoController.text.trim(),
      valor: _converterParaCentavos(_valorController.text.trim()),
    );

    try {
      await servicoService.cadastrarServico(novoServico);

      if (mounted) {
        Navigator.maybePop(context, novoServico.toMap());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar no banco: $e')));
      }
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
            'Adicionar Serviço',
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
              title: 'Dados do Serviço',
              subtitle: 'Preencha as informações do serviço prestado.',
              children: [
                LabeledFormField(
                  icon: Icons.work_outline,
                  label: "Nome do Serviço",
                  field: TextFormField(
                    controller: _nomeController,
                    validator: requiredValidator,
                    decoration: customInputDecoration(
                      hintText: 'Ex: troca de bateria',
                    ),
                  ),
                ),

                LabeledFormField(
                  icon: Icons.notes_outlined,
                  label: "Descrição",
                  field: TextFormField(
                    controller: _descricaoController,
                    maxLines: 4,
                    maxLength: 50,
                    decoration: customInputDecoration(
                      hintText: 'Descreva o que foi feito...',
                    ).copyWith(counterText: ''),
                  ),
                ),

                LabeledFormField(
                  icon: Icons.attach_money,
                  label: "Valor",
                  field: TextFormField(
                    controller: _valorController,
                    validator: requiredValidator,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\,?\d{0,2}'),
                      ),
                    ],
                    decoration: customInputDecoration(hintText: '40,00'),
                  ),
                ),

                ActionButtons(
                  formKey: _formKey,
                  colors: colors,
                  onSave: _handleCadastrar,
                  onCancel:
                      widget.onCancel ?? () => Navigator.maybePop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
