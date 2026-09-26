import 'package:flutter/material.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';

class DataOs extends StatefulWidget {
  final DateTime? dataEntrada;
  final DateTime? dataSaida;
  final String? status;
  final String? relatorio;

  final ValueChanged<DateTime>? onDataEntradaChanged;
  final ValueChanged<String>? onStatusChanged;
  final ValueChanged<String>? onRelatorioChanged;
  final ValueChanged<DateTime>? onDataSaidaChanged;

  /// Avança para a próxima aba da TabBar.
  final VoidCallback? avancarTab;

  const DataOs({
    super.key,
    this.dataEntrada,
    this.dataSaida,
    this.status,
    this.relatorio,
    this.onDataEntradaChanged,
    this.onStatusChanged,
    this.onRelatorioChanged,
    this.onDataSaidaChanged,
    this.avancarTab,
  });

  @override
  State<DataOs> createState() => _DataOsState();
}

class _DataOsState extends State<DataOs> {
  final colors = custom_colors.colorScheme;

  late DateTime dataEntrada;
  DateTime? dataSaida;
  late String status;
  late String relatorio;

  final _relatorioController = TextEditingController();

  static const editableStatuses = [
    'CANCELADA',
    'EM_CONSERTO',
    'EM_ORCAMENTO',
    'ENTREGUE',
    'PAGA',
  ];

  
  @override
  void initState() {
    super.initState();

    dataEntrada = widget.dataEntrada ?? DateTime.now();
    dataSaida = widget.dataSaida;

    status = widget.status ?? 'EM_CONSERTO';

    relatorio = widget.relatorio ?? '';
    _relatorioController.text = relatorio;
  }

  @override
  void dispose() {
    _relatorioController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DataOs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.status != oldWidget.status &&
        widget.status != null) {
      setState(() {
        status = widget.status!;
      });
    }
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
      initialDate: dataEntrada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      helpText: 'Selecione a data de entrada',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );

    if (selecionada == null) return;

    setState(() {
      dataEntrada = selecionada;
    });

    widget.onDataEntradaChanged?.call(selecionada);
  }

  Future<void> _alterarDataSaida() async {
    final dataInicial = dataSaida ?? DateTime.now();

    final selecionada = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      helpText: 'Alterar data de saída',
      cancelText: 'Cancelar',
      confirmText: 'Salvar',
    );

    if (selecionada == null) return;

    setState(() {
      dataSaida = selecionada;
    });

    widget.onDataSaidaChanged?.call(selecionada);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data de saída alterada com sucesso.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _editarRelatorio() async {
    _relatorioController.text = relatorio;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  24,
                  16,
                  24,
                  24,
                ),
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
                            color: colors.primary,
                          ),
                          const Text(
                            'Relatório da OS',
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
                        maxLength: 256,
                        textCapitalization:
                            TextCapitalization.sentences,
                        decoration: customInputDecoration(
                          hintText:
                              'Digite observações sobre a OS...',
                        ).copyWith(
                          alignLabelWithHint: true,
                          counterStyle: TextStyle(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        onChanged: (value) {
                          setModalState(() {});

                          setState(() {
                            relatorio = value;
                          });

                          widget.onRelatorioChanged?.call(value);
                        },
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.check),
                          label: const Text(
                            'Concluir edição',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onSecondary,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 650,
          ),
          child: Column(
            spacing: 24,
            children: [
              _buildFormCard(), 
            ],
          )
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 28,
        ),
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
                          decoration: customInputDecoration(
                            hintText: 'Data',
                          ).copyWith(
                            suffixIcon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 20,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          child: Text(
                            _formatDate(dataEntrada),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
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
                        onTap: dataSaida == null
                            ? null
                            : _alterarDataSaida,
                        child: InputDecorator(
                          decoration: customInputDecoration(
                            hintText: 'Automática',
                          ).copyWith(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            suffixIcon: dataSaida == null
                                ? const Icon(
                                    Icons.hourglass_empty,
                                    color: Colors.grey,
                                    size: 20,
                                  )
                                : const Icon(
                                    Icons.edit_calendar_outlined,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          child: Text(
                            dataSaida == null
                                ? 'Indefinida'
                                : _formatDate(dataSaida),
                            style: TextStyle(
                              fontSize: 14,
                              color: dataSaida == null
                                  ? Colors.grey.shade600
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

            if (dataSaida != null) ...[
              Row(
                spacing: 6,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 15,
                    color: Colors.grey,
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
            ],

            _buildFieldLabel(
              Icons.sync_alt,
              'Status',
            ),

            _buildStatusField(),

            _buildFieldLabel(
              Icons.description_outlined,
              'Relatório',
            ),

            InkWell(
              onTap: _editarRelatorio,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: 130,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: relatorio.isEmpty
                    ? Row(
                      spacing: 6,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.edit_note,
                            color: colors.onSurfaceVariant,
                          ),
                          Expanded(
                            child: Text(
                              'Toque para adicionar observações...',
                              style: TextStyle(
                                color:
                                    colors.onSurfaceVariant,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                      spacing: 18,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            relatorio,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.45,
                            ),
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 17,
                                color: colors.primary,
                              ),
                              Text(
                                'Editar',
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),

            Text(
              '${relatorio.length}/256 caracteres',
              style: TextStyle(
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  DefaultTabController.of(context).animateTo(1);
                },
                icon: const Icon(
                  Icons.build,
                ),
                label: const Text(
                  'Adicionar Peças',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onSecondary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
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
    );
  }

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      spacing: 6,
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
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(
    IconData icon,
    String label,
  ) {
    return Row(
      spacing: 6,
      children: [
        Icon(
          icon,
          size: 20,
          color: colors.primary,
        ),
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
    if (status == 'CONCLUIDA') {
      return InputDecorator(
        decoration: customInputDecoration(
          hintText: 'Status',
        ).copyWith(
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
                color: _statusColor(status),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _statusLabel(status),
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

    return DropdownButtonFormField<String>(
      value: status,
      decoration: customInputDecoration(
        hintText: 'Selecione o status',
      ),
      items: editableStatuses.map((value) {
        final color = _statusColor(value);

        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(_statusLabel(value)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          status = value;
        });

        widget.onStatusChanged?.call(value);
      },
    );
  }

}


