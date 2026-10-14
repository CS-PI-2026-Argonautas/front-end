import 'package:flutter/material.dart';
import 'package:frontend/ui/widgets/form/form_section_tile.dart';
class FormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final double fieldSpacing;
  final AutovalidateMode autovalidateMode;

  const FormCard({
    super.key,
    required this.formKey,
    required this.title,
    required this.subtitle,
    required this.children,
    this.fieldSpacing = 24,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            spacing: fieldSpacing,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormSectionTile(title: title, subtitle: subtitle),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}