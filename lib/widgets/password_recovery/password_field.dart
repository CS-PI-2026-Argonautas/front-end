import 'package:flutter/material.dart';


class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;
  final String? Function(String?)? validator;
  final bool sensitiveContent;

  PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.enabled,
    required this.sensitiveContent,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: widget.controller,

      enabled: widget.enabled,

      validator: widget.validator,

      obscureText: _obscureText,

      decoration: InputDecoration(
        hintText: widget.hintText,
        

        suffixIcon: widget.sensitiveContent
        ? 
        IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),

          onPressed: (){
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
        : null,

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}