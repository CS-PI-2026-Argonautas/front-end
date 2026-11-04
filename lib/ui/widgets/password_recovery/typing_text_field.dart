import 'package:flutter/material.dart';
import 'package:frontend/ui/style/inputDecorationStyles.dart';

class TypingTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;
  final String? Function(String?)? validator;
  final bool sensitiveContent;
  final bool isPassword;
  final ValueChanged<String>? onChanged;

  TypingTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.enabled,
    required this.sensitiveContent,
    required this.isPassword,
    this.validator,
    this.onChanged,
  });

  @override
  State<TypingTextField> createState() => _TypingTextFieldState();
}

class _TypingTextFieldState extends State<TypingTextField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,

      enabled: widget.enabled,

      validator: widget.validator,

      obscureText: widget.isPassword ? !_obscureText : _obscureText,

      decoration: customInputDecoration(hintText: widget.hintText).copyWith(
        suffixIcon: widget.sensitiveContent
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
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
