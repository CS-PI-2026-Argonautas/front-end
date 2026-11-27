import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/fire_base/repositories/item_repository.dart';
import 'package:frontend/fire_base/services/item_service.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/lists/client_list.dart';
import 'package:frontend/ui/pages/lists/item_list.dart';
import 'package:frontend/ui/pages/lists/os_list_page.dart';
import 'package:frontend/ui/pages/lists/service_list.dart';
import 'package:frontend/ui/pages/product_registration/product_form.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/menu.dart';

class ProductRegistration extends StatefulWidget {
  final bool abertoPelaOS;
  final Item? itemEdicao;

  const ProductRegistration({
    super.key,
    this.abertoPelaOS = false,
    this.itemEdicao,
  });

  @override
  State<ProductRegistration> createState() => _ProductRegistrationState();
}

class _ProductRegistrationState extends State<ProductRegistration> {
  late final ItemService itemService;

  bool _salvando = false;
  bool get modoEdicao => widget.itemEdicao != null;

  @override
  void initState() {
    super.initState();
    itemService = ItemService(repository: ItemRepository());
  }

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: modoEdicao
            ? 'Editar produto'
            : widget.abertoPelaOS
            ? 'Nova peça'
            : 'Cadastro de produtos',
      ),

      endDrawer: widget.abertoPelaOS
          ? null
          : Menu(
              currentIndex: 3,
              onTap: (index) {
                Navigator.pop(context);

                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClientList()),
                  );
                }

                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ItemList()),
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

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),

                child: Column(
                  spacing: 24,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ProductForm(
                      itemEdicao: widget.itemEdicao,

                      onCancel: () {
                        Navigator.pop(context);
                      },

                      onSave: (Item item) async {
                        if (_salvando) return;

                        setState(() {
                          _salvando = true;
                        });

                        try {
                          late final Item itemSalvo;

                          if (modoEdicao) {
                            await itemService.update(item);
                            itemSalvo = item;
                          } else {
                            await itemService.create(item);
                            itemSalvo = item;
                          }

                          if (!mounted) return;

                          if (widget.abertoPelaOS) {
                            Navigator.pop(context, itemSalvo);
                            return;
                          }

                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),

                                title: Row(
                                  spacing: 6,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 28,
                                    ),
                                    Text(
                                      modoEdicao
                                          ? 'Alteração realizada'
                                          : 'Cadastro realizado',
                                    ),
                                  ],
                                ),

                                content: Text(
                                  modoEdicao
                                      ? 'O produto foi atualizado com sucesso.'
                                      : 'O produto foi salvo com sucesso.',
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text('Continuar'),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Dashboard(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text('Ir para o início'),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          if (!mounted) return;

                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text('Erro'),
                                content: Text(
                                  'Não foi possível salvar o produto.\n\n$e',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              _salvando = false;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
