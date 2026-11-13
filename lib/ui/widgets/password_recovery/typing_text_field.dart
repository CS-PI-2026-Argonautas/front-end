// import 'package:flutter/material.dart';


// class TypingTextField extends StatefulWidget {
//   final TextEditingController? controller;
//   final String hintText;
//   final bool enabled;
//   final String? Function(String?)? validator;
//   final bool sensitiveContent;
//   final bool isPassword;
//   final ValueChanged<String>? onChanged;
//   final Color? fillColor;

//   TypingTextField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     required this.enabled,
//     required this.sensitiveContent,
//     required this.isPassword,
//     this.validator,
//     this.onChanged,
//     this.fillColor
//   });

//   @override
//   State<TypingTextField> createState() => _TypingTextFieldState();
// }

// class _TypingTextFieldState extends State<TypingTextField> {


//   bool _obscureText = false;

//   @override
//   Widget build(BuildContext context){
//     return TextFormField(
//       controller: widget.controller,

//       enabled: widget.enabled,

//       validator: widget.validator,

//       obscureText: widget.isPassword ? !_obscureText : _obscureText,

//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         filled: true,
//         fillColor: widget.fillColor ?? Colors.white,
//         suffixIcon: widget.sensitiveContent
//         ? 
//         IconButton(
//           icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),

//           onPressed: (){
//             setState(() {
//               _obscureText = !_obscureText;
//             });
//           },
//         )
//         : null,

//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(width: 2),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(width: 1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       onChanged: widget.onChanged,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';

class TypingTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;
  final String? Function(String?)? validator;
  final bool sensitiveContent;
  final bool isPassword;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;

  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const TypingTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.enabled,
    required this.sensitiveContent,
    required this.isPassword,
    this.validator,
    this.onChanged,
    this.fillColor,
    this.inputFormatters,
    this.maxLength
  });

  @override
  State<TypingTextField> createState() => _TypingTextFieldState();
}

class _TypingTextFieldState extends State<TypingTextField> {
  bool _obscureText = false;

  final colors = custom_colors.colorScheme;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      validator: widget.validator,
      obscureText: widget.isPassword && !_obscureText,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      decoration: customInputDecoration(
        hintText: widget.hintText,
      ).copyWith(
        filled: true,
        fillColor: widget.fillColor ?? colors.surfaceContainerHigh,
        suffixIcon: widget.sensitiveContent
            ? IconButton(
                tooltip: _obscureText
                    ? 'Ocultar senha'
                    : 'Mostrar senha',
                icon: Icon(
                  _obscureText
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: colors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      onChanged: widget.onChanged,
    );
  }
}
