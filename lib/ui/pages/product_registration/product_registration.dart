import 'package:flutter/material.dart';

import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/fire_base/repositories/item_repository.dart';
import 'package:frontend/fire_base/services/item_service.dart';

import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/edit_item/item_edition.dart';
import 'package:frontend/ui/pages/product_registration/product_form.dart';
import 'package:frontend/ui/pages/stand_in_page.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/menu.dart';

class ProductRegistration extends StatelessWidget {
  const ProductRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    final ItemService itemService = ItemService(
      ItemRepository(),
    );

    return Scaffold(
      backgroundColor: colors.surface,

      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Cadastro de produtos',
      ),

       endDrawer: Menu(
        currentIndex: 0,
        onTap: (index) {
          Navigator.pop(context);

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductRegistration(),
              ),
            );
          }

          if (index == 0 || index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StandInPage(),
              ),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ItemEdition(),
              ),
            );
          }

          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),

            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),

                child: Column(
                  spacing: 24,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ProductForm(
                      onCancel: () {
                        Navigator.pop(context);
                      },

                      onSave: (Item item) async {
                        try {
                          await itemService.create(item);

                          if (!context.mounted) return;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),

                                title: const Row(
                                  spacing: 6,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 28,
                                    ),
                                    Text("Cadastro realizado"),
                                  ],
                                ),

                                content: const Text(
                                  "O produto foi salvo com sucesso.",
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Continuar"),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Dashboard(),
                                        ),
                                      );
                                    },
                                    child: const Text("Ir para o início"),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          if (!context.mounted) return;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Erro"),
                                content: Text(
                                  "Não foi possível salvar o produto.\n\n$e",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
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