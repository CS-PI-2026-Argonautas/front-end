import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/fire_base/models/service.dart';
import 'package:frontend/fire_base/services/service_service.dart';
import 'package:frontend/ui/pages/person_registration/person_registration.dart';

import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';

import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/menu.dart';
import 'package:frontend/ui/widgets/form/form_card.dart';
import 'package:frontend/ui/widgets/form/form_field_label.dart';
import 'package:frontend/ui/widgets/form/action_buttons.dart';

import 'package:frontend/ui/pages/lists/os_list_page.dart';
import 'package:frontend/ui/pages/lists/service_list.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/utils/formatters/currency_input_formatter.dart';

class ServiceRegistration extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;

  final Service? initialService;

  // Indica se a tela foi aberta pela OS.
  // Quando true, o menu lateral não será apresentado.
  final bool abertoPelaOS;

  const ServiceRegistration({
    super.key,
    this.onBack,
    this.onClose,
    this.onCancel,
    this.onSubmit,
    this.initialService,
    this.abertoPelaOS = false,
  });

  @override
  State<ServiceRegistration> createState() => _ServiceRegistrationState();
}

class _ServiceRegistrationState extends State<ServiceRegistration> {
  final _formKey = GlobalKey<FormState>();

  final colors = custom_colors.colorScheme;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();

  final ServiceService _service = ServiceService();

  bool _salvando = false;

  bool get _editando => widget.initialService != null;

  @override
  void initState() {
    super.initState();

    _preencherCampos();
  }

  void _preencherCampos() {
    final service = widget.initialService;

    if (service == null) return;

    _nameController.text = service.name;
    _descriptionController.text = service.description;

    // Converte centavos para o formato monetário brasileiro.
    _valueController.text = Dinheiro(
      service.valueInCents,
    ).formatado().replaceFirst('R\$', '').trim();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();

    super.dispose();
  }

  int _obterValorEmCentavos() {
    return Dinheiro.fromTexto(_valueController.text).centavos;
  }

  // Executa a gravação sem bloquear a navegação.
  // O Firestore mantém as operações pendentes para sincronização.
  Future<void> _persistir(Service service) async {
    try {
      if (_editando) {
        await _service.update(service);
      } else {
        await _service.create(service);
      }
    } catch (e) {
      debugPrint('Erro ao persistir serviço: $e');
    }
  }

  void _salvar() {
    if (_salvando) return;

    if (!_formKey.currentState!.validate()) return;

    final nome = _nameController.text.trim();
    final descricao = _descriptionController.text.trim();
    final valorEmCentavos = _obterValorEmCentavos();

    if (nome.isEmpty) return;

    if (valorEmCentavos <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe um valor maior que zero.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (descricao.length > 50) return;

    final service = Service(
      id: widget.initialService?.id,
      name: nome,
      description: descricao,
      valueInCents: valorEmCentavos,
    );

    setState(() {
      _salvando = true;
    });

    // Não aguarda a confirmação do servidor.
    unawaited(_persistir(service));

    // A listagem será atualizada pelo watchServices().
    widget.onSubmit?.call();

    Navigator.maybePop(context);
  }

  void _cancelar() {
    if (widget.onCancel != null) {
      widget.onCancel!.call();
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,

      appBar: Header(
        onBack: widget.onBack ?? () => Navigator.maybePop(context),
        title: _editando ? 'Edição de serviços' : 'Cadastro de serviços',
      ),

      // A OS não deve apresentar o menu lateral.
      endDrawer: widget.abertoPelaOS
          ? null
          : Menu(
              currentIndex: 3,
              onTap: (index) {
                Navigator.pop(context);

                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonRegistration(),
                    ),
                  );
                }

                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductRegistration(),
                    ),
                  );
                }

                if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OsListPage()),
                  );
                }

                if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceList(),
                    ),
                  );
                }

                if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
                }
              },
            ),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(children: [_buildFormCard()]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return FormCard(
      formKey: _formKey,
      title: 'Informações do Serviço',
      subtitle: 'Complete os campos do serviço abaixo.',
      fieldSpacing: 18,
      autovalidateMode: AutovalidateMode.disabled,
      children: [
        // Nome do serviço
        const FormFieldLabel(
          icon: Icons.work_outline,
          label: 'Nome do serviço *',
        ),

        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.sentences,
          decoration: customInputDecoration(
            hintText: 'Digite o nome do serviço',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe o nome do serviço.';
            }

            return null;
          },
        ),

        // Descrição
        const FormFieldLabel(icon: Icons.notes_outlined, label: 'Descrição'),

        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          maxLength: 50,
          textCapitalization: TextCapitalization.sentences,
          decoration: customInputDecoration(
            hintText: 'Descreva os detalhes do serviço...',
          ),
          validator: (value) {
            if ((value?.length ?? 0) > 50) {
              return 'A descrição não pode ultrapassar 50 caracteres.';
            }

            return null;
          },
        ),

        // Valor
        const FormFieldLabel(icon: Icons.attach_money, label: 'Valor *'),

        TextFormField(
          controller: _valueController,
          keyboardType: TextInputType.number,
          inputFormatters: [CurrencyInputFormatter()],
          decoration: customInputDecoration(hintText: '0,00'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe o valor do serviço.';
            }

            final centavos = Dinheiro.fromTexto(value).centavos;

            if (centavos <= 0) {
              return 'O valor deve ser maior que zero.';
            }

            return null;
          },
        ),

        // Botões de ação
        ActionButtons(
          formKey: _formKey,
          colors: colors,
          onCancel: _cancelar,
          onSave: _salvar,
        ),
      ],
    );
  }
}
