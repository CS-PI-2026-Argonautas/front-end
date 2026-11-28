import 'package:flutter/material.dart';
import 'package:frontend/fire_base/Enums/StatusOrderService.dart';
import 'package:frontend/fire_base/services/client_service.dart';
import 'package:frontend/fire_base/services/address_service.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/models/client.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/ui/pages/os/service_order_state.dart';
import 'package:frontend/ui/pages/person_registration/person_registration_address.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:frontend/ui/widgets/fields/equipment_field.dart';
import 'package:frontend/ui/widgets/form/section_label.dart';
import 'package:frontend/ui/pages/person_registration/person_registration.dart';
import 'package:frontend/fire_base/models/equipment.dart';
import 'package:frontend/fire_base/services/equipment_service.dart';
import 'package:frontend/ui/pages/equipment_data/equipment_data.dart';

class DataOs extends StatefulWidget {
  final ServiceOrderState serviceOrderState;
  final VoidCallback? onChanged;
  final VoidCallback? avancarTab;
  final ValueChanged<bool> onDadosObrigatoriosChanged;

  const DataOs({
    super.key,
    required this.serviceOrderState,
    required this.onDadosObrigatoriosChanged,
    this.onChanged,
    this.avancarTab,
  });

  @override
  State<DataOs> createState() => _DataOsState();
}

class _DataOsState extends State<DataOs>
    with AutomaticKeepAliveClientMixin<DataOs> {
  @override
  bool get wantKeepAlive => true;

  ServiceOrder get _os => widget.serviceOrderState.serviceOrder;

  void _editarOs(void Function(ServiceOrder) editar) {
    setState(() => widget.serviceOrderState.applyUserEdit(editar));
  }

  final colors = custom_colors.colorScheme;
  final EquipmentService _equipamentoService = EquipmentService();
  final AddressService _enderecoService = AddressService();
  final ClientService _clienteService = ClientService();
  final _relatorioController = TextEditingController();

  List<Client> clientesDisponiveis = [];

  static const editableStatuses = [
    ServiceOrderStatus.CANCELADA,
    ServiceOrderStatus.EM_CONSERTO,
    ServiceOrderStatus.EM_ORCAMENTO,
    ServiceOrderStatus.ENTREGUE,
    ServiceOrderStatus.PAGA,
  ];

  bool get _formHabilitado => _os.client != null;

  bool get _formValido =>
      _os.client != null &&
      _os.serviceAddress != null &&
      _os.equipment != null &&
      !_os.equipment!.isEmpty;

  bool get _equipamentoBloqueado => _os.equipmentBlocked;

  void _notificar() {
    widget.onDadosObrigatoriosChanged(_formValido);
    widget.onChanged?.call();
  }

  @override
  void initState() {
    super.initState();

    _relatorioController.text = _os.report;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _notificar();
    });

    _carregarClientes();
  }

  @override
  void dispose() {
    _relatorioController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _montarDadosOs() {
    return {
      'status': _os.status.name,
      'equipamento_bloqueado': _equipamentoBloqueado,
      'dataEntrada': _os.entryDate,
      'dataSaida': _os.exitDate,
      'relatorio': _os.report,
      'cliente': _os.client?.toFirestore(),
      'endereco': _os.serviceAddress?.toFirestore(),
      'equipamento': _os.equipment?.toFirestore(),
    };
  }

  ServiceOrderEquipment _equipamentoDe(Object? dados) {
    if (dados is ServiceOrderEquipment) {
      return dados;
    }

    if (dados is Equipment) {
      return ServiceOrderEquipment(
        brand: dados.brand,
        model: dados.model,
        serialNumber: dados.serialNumber,
      );
    }

    return ServiceOrderEquipment.fromMap(
      Map<String, dynamic>.from(dados as Map),
    );
  }

  Map<String, dynamic>? get _equipamentoParaSecao {
    final equipamento = _os.equipment;

    if (equipamento == null || equipamento.isEmpty) {
      return null;
    }

    return equipamento.toFirestore();
  }

  String _formatarEnderecoServico(ServiceAddress e) {
    final numero = (e.number == null || e.number!.isEmpty)
        ? ''
        : ', ${e.number}';

    final complemento = (e.complement == null || e.complement!.isEmpty)
        ? ''
        : ', ${e.complement}';

    return '${e.street}$numero$complemento - ${e.city}/${e.state}';
  }

  bool _validarFormulario() {
    if (_os.client == null) {
      _mostrarErro('Selecione um cliente.');
      return false;
    }

    if (_os.serviceAddress == null) {
      _mostrarErro('Selecione um endereço.');
      return false;
    }

    if (_os.equipment == null || _os.equipment!.isEmpty) {
      _mostrarErro('Selecione um equipamento.');
      return false;
    }

    return true;
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _carregarClientes() async {
    try {
      final clientes = await _clienteService.listar();

      if (!mounted) return;

      setState(() {
        clientesDisponiveis = clientes;
      });
    } catch (e) {
      debugPrint('Erro ao carregar clientes: $e');

      if (mounted) {
        _mostrarErro('Não foi possível carregar os clientes.');
      }
    }
  }

  void _selecionarCliente(Client cliente) {
    _editarOs((os) => os.setClient(cliente));

    _notificar();
  }

  Future<void> _abrirCadastroEquipamento() async {
    final resultado = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (routeContext) => EquipmentData(
          osDados: _montarDadosOs(),
          onSubmit: (dados) {
            Navigator.pop(routeContext, dados);
          },
        ),
      ),
    );

    if (!mounted || resultado == null) return;

    _associarEquipamento(resultado);
  }

  bool _podeTrocarEquipamento() {
    if (!_equipamentoBloqueado) return true;

    _mostrarErro('Não é possível trocar um equipamento bloqueado.');
    return false;
  }

  void _associarEquipamento(Object equipamento) {
    if (!_podeTrocarEquipamento()) return;

    _editarOs((os) => os.equipment = _equipamentoDe(equipamento));

    _notificar();
  }

  Future<void> _confirmarEdicaoEquipamento(dynamic equipamento) async {
    final confirmou =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Editar equipamento?'),
            content: const Text(
              'As alterações podem substituir os dados deste equipamento. '
              'Deseja continuar?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('CANCELAR'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text('EDITAR', style: TextStyle(color: colors.primary)),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmou || !mounted) return;

    await _abrirCadastroEquipamento();
  }

  Future<void> _buscarEquipamento() async {
    if (!_podeTrocarEquipamento()) return;

    final List<Equipment> equipamentos;

    try {
      equipamentos = await _equipamentoService.listar();
    } catch (e) {
      if (!mounted) return;

      _mostrarErro('Não foi possível carregar os equipamentos.');
      return;
    }

    if (!mounted || !_podeTrocarEquipamento()) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SelectionBottomSheet<Equipment>(
          title: 'Selecionar equipamento',
          items: equipamentos,
          searchText: 'Procurar equipamento',
          actionText: 'Novo equipamento',
          itemTitle: (e) => '${e.brand} ${e.model}',
          itemSubtitle: (e) => 'Nº série ${e.serialNumber}',
          itemIcon: Icons.scale_outlined,
          loading: false,
          onAction: () {
            Navigator.pop(sheetContext);
            if (!_podeTrocarEquipamento()) return;
            _abrirCadastroEquipamento();
          },
          onSelect: (e) {
            _associarEquipamento(e);
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Indefinida';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _statusLabel(String value) {
    switch (value) {
      case 'EM_CONSERTO':
        return 'Em conserto';
      case 'EM_ORCAMENTO':
        return 'Em orçamento';
      case 'ENTREGUE':
        return 'Entregue';
      case 'PAGA':
        return 'Paga';
      case 'CANCELADA':
        return 'Cancelada';
      case 'CONCLUIDA':
        return 'Concluída';
      default:
        return value;
    }
  }

  Color _statusColor(String value) {
    switch (value) {
      case 'EM_CONSERTO':
        return Colors.orange;
      case 'EM_ORCAMENTO':
        return Colors.blue;
      case 'ENTREGUE':
        return Colors.cyan;
      case 'PAGA':
        return Colors.teal;
      case 'CANCELADA':
        return Colors.red;
      case 'CONCLUIDA':
        return Colors.green;
      default:
        return colors.primary;
    }
  }

  Future<void> _selecionarDataEntrada() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: _os.entryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Selecione a data de entrada',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );

    if (selecionada == null || !mounted) return;

    _editarOs((os) => os.entryDate = selecionada);

    widget.onChanged?.call();
  }

  Future<void> _alterarDataSaida() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: _os.exitDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Alterar data de saída',
      cancelText: 'Cancelar',
      confirmText: 'Salvar',
    );

    if (selecionada == null || !mounted) return;

    _editarOs((os) => os.exitDate = selecionada);

    widget.onChanged?.call();

    if (mounted) {
      _mostrarErro('Data de saída alterada com sucesso.');
    }
  }

  Future<void> _editarRelatorio() async {
    _relatorioController.text = _os.report;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: SafeArea(
                  top: false,
                  child: Column(
                    spacing: 18,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: colors.secondary,
                          ),
                          const Text(
                            'Relatório da ordem de serviço',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Adicione observações sobre o andamento do conserto.',
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      TextField(
                        controller: _relatorioController,
                        autofocus: true,
                        maxLines: 7,
                        maxLength: ServiceOrder.reportLimit,
                        textCapitalization: TextCapitalization.sentences,
                        decoration:
                            customInputDecoration(
                              hintText: 'Digite observações sobre a OS...',
                            ).copyWith(
                              alignLabelWithHint: true,
                              counterStyle: TextStyle(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                        onChanged: (value) {
                          setModalState(() {});

                          _editarOs((os) => os.report = value);

                          widget.onChanged?.call();
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(modalContext);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text(
                            'Concluir edição',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onSecondary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _abrirListaClientes() async {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SelectionBottomSheet<Client>(
          title: 'Selecionar cliente',
          items: clientesDisponiveis,
          searchText: 'Procurar cliente',
          actionText: 'Novo cliente',
          itemTitle: (c) => c.name,
          itemSubtitle: (c) => c.contact.phone,
          itemIcon: Icons.person_outline,
          loading: false,
          onAction: () async {
            Navigator.pop(sheetContext);

            final retorno = await Navigator.push<dynamic>(
              context,
              MaterialPageRoute(
                builder: (_) => const PersonRegistration(
                  retornarDadosAoFechar: true,
                  abertoPelaOS: true,
                ),
              ),
            );

            if (retorno == null || !mounted) return;

            final idCliente = retorno is Map ? retorno['id']?.toString() : null;

            if (idCliente == null || idCliente.isEmpty) {
              _mostrarErro(
                'Não foi possível identificar o cliente cadastrado.',
              );
              return;
            }

            try {
              final clientes = await _clienteService.listar();

              if (!mounted) return;

              setState(() {
                clientesDisponiveis = clientes;
              });

              Client? clienteEncontrado;

              for (final cliente in clientes) {
                if (cliente.id.toString() == idCliente) {
                  clienteEncontrado = cliente;
                  break;
                }
              }

              if (clienteEncontrado == null) {
                _mostrarErro('Cliente cadastrado não foi encontrado.');
                return;
              }

              _selecionarCliente(clienteEncontrado);
            } catch (e) {
              debugPrint('Erro ao atualizar clientes: $e');

              if (mounted) {
                _mostrarErro('Não foi possível atualizar a lista de clientes.');
              }
            }
          },
          onSelect: (cliente) {
            _selecionarCliente(cliente);
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  Future<void> _abrirListaEnderecos() async {
    final cliente = _os.client;

    if (cliente == null) return;

    final List<Address> enderecos;

    try {
      enderecos = await _enderecoService.getByClientId(cliente.id.toString());
    } catch (e) {
      debugPrint('Erro ao carregar endereços: $e');

      if (!mounted) return;

      _mostrarErro('Não foi possível carregar os endereços.');
      return;
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SelectionBottomSheet<Address>(
          title: 'Selecionar endereço',
          items: enderecos,
          searchText: 'Procurar endereço',
          actionText: 'Novo endereço',
          itemTitle: (e) => '${e.publicPlace}, ${e.number}, ${e.complement}',
          itemSubtitle: (e) =>
              '${e.city} - ${e.uf.name}'
              '${e.zipCode.isEmpty ? '' : ' • CEP ${e.zipCode}'}',
          itemIcon: Icons.location_on_outlined,
          loading: false,
          onAction: () async {
            Navigator.pop(sheetContext);

            final novo = await Navigator.push<Address>(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const PersonRegistrationAddress(abertoPelaOS: true),
              ),
            );

            if (novo == null || !mounted) return;

            try {
              await _enderecoService.save(cliente.id.toString(), novo);

              if (!mounted) return;

              _editarOs((os) => os.setServiceAddress(novo));

              _notificar();
            } catch (e) {
              debugPrint('Erro ao salvar endereço: $e');

              if (mounted) {
                _mostrarErro('Não foi possível salvar o endereço.');
              }
            }
          },
          onSelect: (endereco) {
            _editarOs((os) => os.setServiceAddress(endereco));

            _notificar();
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 18,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(spacing: 24, children: [_buildFormCard()]),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    final relatorio = _os.report;

    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          spacing: 18,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              'Informações da ordem de serviço',
              'Insira os dados da ordem de serviço.',
            ),
            _buildClienteEnderecoLabel(
              'Cliente*',
              onAdd: _abrirListaClientes,
              addLabel: 'Adicionar Cliente',
              icon: Icons.person_outline,
            ),
            _buildClienteSelecionado(),
            _buildClienteEnderecoLabel(
              'Endereço*',
              onAdd: _os.client == null ? null : _abrirListaEnderecos,
              addLabel: 'Adicionar Endereço',
              icon: Icons.home_outlined,
              dicaDesabilitado: 'Selecione um cliente primeiro.',
            ),
            _buildEnderecoSelecionado(),
            EquipmentSection(
              equipamento: _equipamentoParaSecao,
              onBuscar: _buscarEquipamento,
              onOpenCadastro: _abrirCadastroEquipamento,
              onEdit: _confirmarEdicaoEquipamento,
            ),
            if (!_formHabilitado) _buildAvisoSelecioneCliente(),
            Opacity(
              opacity: _formHabilitado ? 1.0 : 0.4,
              child: AbsorbPointer(
                absorbing: !_formHabilitado,
                child: Column(
                  spacing: 18,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      'Andamento da OS',
                      'Atualize as informações referentes ao conserto do equipamento.',
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              _buildFieldLabel(
                                Icons.calendar_today_outlined,
                                'Entrada',
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: _selecionarDataEntrada,
                                child: InputDecorator(
                                  decoration:
                                      customInputDecoration(
                                        hintText: 'Data',
                                      ).copyWith(
                                        suffixIcon: const Icon(
                                          Icons.calendar_month_outlined,
                                          size: 20,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 14,
                                            ),
                                      ),
                                  child: Text(
                                    _formatDate(_os.entryDate),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              _buildFieldLabel(
                                Icons.event_available_outlined,
                                'Saída',
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: _alterarDataSaida,
                                child: InputDecorator(
                                  decoration:
                                      customInputDecoration(
                                        hintText: 'Automática',
                                      ).copyWith(
                                        filled: true,
                                        fillColor: colors.surfaceContainerLow,
                                        suffixIcon: _os.exitDate == null
                                            ? Icon(
                                                Icons.hourglass_empty,
                                                color: Colors.blueGrey.shade400,
                                                size: 20,
                                              )
                                            : Icon(
                                                Icons.edit_calendar_outlined,
                                                color: Colors.blueGrey.shade400,
                                                size: 20,
                                              ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 14,
                                            ),
                                      ),
                                  child: Text(
                                    _os.exitDate == null
                                        ? 'Indefinida'
                                        : _formatDate(_os.exitDate),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _os.exitDate == null
                                          ? Colors.blueGrey.shade600
                                          : colors.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_os.exitDate != null)
                      Row(
                        spacing: 6,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 15,
                            color: Colors.blueGrey,
                          ),
                          Text(
                            'Toque para corrigir a data de saída.',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    _buildFieldLabel(Icons.sync_alt, 'Status'),
                    _buildStatusField(),
                    _buildFieldLabel(Icons.description_outlined, 'Relatório *'),
                    InkWell(
                      onTap: _editarRelatorio,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 130),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: relatorio.isEmpty
                            ? Row(
                                spacing: 6,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.edit_note,
                                    color: colors.onSurfaceVariant,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Toque para adicionar observações...',
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                spacing: 18,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    relatorio,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.45,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 17,
                                        color: colors.secondary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Text(
                      '${relatorio.length}/${ServiceOrder.reportLimit} caracteres',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _formValido
                            ? () {
                                if (!_validarFormulario()) return;
                                widget.avancarTab?.call();
                              }
                            : null,
                        icon: const Icon(Icons.build),
                        label: const Text(
                          'Adicionar Peças',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: _formValido ? 3 : 0,
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onSecondary,
                          disabledBackgroundColor: colors.surfaceContainerLow,
                          disabledForegroundColor: colors.onSurfaceVariant,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'A conclusão da OS não altera a data de saída.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClienteEnderecoLabel(
    String text, {
    VoidCallback? onAdd,
    String addLabel = 'Adicionar',
    required IconData icon,
    String? dicaDesabilitado,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Row(
          children: [
            SectionLabel(icon: icon, text: text),
            const Spacer(),
            if (onAdd != null || addLabel.isNotEmpty)
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: Text(addLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
        if (onAdd == null && dicaDesabilitado != null)
          Text(
            dicaDesabilitado,
            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
      ],
    );
  }

  Widget _buildClienteSelecionado() {
    final cliente = _os.client;

    if (cliente == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.person, color: colors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cliente selecionado',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  cliente.name,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _abrirListaClientes,
            icon: Icon(Icons.sync_alt, color: colors.secondary),
            tooltip: 'Trocar cliente',
          ),
        ],
      ),
    );
  }

  Widget _buildEnderecoSelecionado() {
    final endereco = _os.serviceAddress;

    if (endereco == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: colors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Endereço selecionado',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatarEnderecoServico(endereco),
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _abrirListaEnderecos,
            icon: Icon(Icons.sync_alt, color: colors.primary),
            tooltip: 'Trocar endereço',
          ),
        ],
      ),
    );
  }

  Widget _buildAvisoSelecioneCliente() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.amber.shade800, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Selecione um cliente para preencher o andamento da OS '
              '(datas, status e relatório).',
              style: TextStyle(fontSize: 13, color: Colors.amber.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.description, color: colors.secondary),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(IconData icon, String label) {
    return Row(
      spacing: 6,
      children: [
        Icon(icon, size: 20, color: colors.primary),
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

  Widget _buildStatusField() {
    final status = _os.status;

    final opcoes = ServiceOrderStatus.values
        .where(
          (s) =>
              s != ServiceOrderStatus.CONCLUIDA ||
              status == ServiceOrderStatus.CONCLUIDA,
        )
        .toList();

    if (!editableStatuses.contains(status)) {
      return InputDecorator(
        decoration: customInputDecoration(hintText: 'Status').copyWith(
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: const Icon(
            Icons.lock_outline,
            color: Colors.grey,
            size: 20,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: _statusColor(status.name),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _statusLabel(status.name),
              style: TextStyle(
                fontSize: 14,
                color: colors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<ServiceOrderStatus>(
      value: status,
      decoration: customInputDecoration(hintText: 'Selecione o status'),
      items: opcoes.map((value) {
        return DropdownMenuItem<ServiceOrderStatus>(
          value: value,
          child: Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: _statusColor(value.name),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(_statusLabel(value.name)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        _editarOs((os) => os.changeStatus(value));

        widget.onChanged?.call();
      },
    );
  }
}