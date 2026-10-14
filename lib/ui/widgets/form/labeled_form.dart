import 'package:flutter/material.dart';
import 'section_label.dart';

// use este componente para agrupar um titulo com icone e um campo de formulario, passando o icone, o texto do titulo e o widget do campo em field
class LabeledFormField extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget field;

  const LabeledFormField({
    super.key,
    required this.icon,
    required this.label,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        SectionLabel(
          icon: icon,
          text: label,
        ),
        field,
      ],
    );
  }
}