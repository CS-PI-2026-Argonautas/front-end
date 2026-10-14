import 'package:flutter/material.dart';


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
  Widget build(BuildContext context){
    return TextFormField(
      controller: widget.controller,

      enabled: widget.enabled,

      validator: widget.validator,

      obscureText: widget.isPassword ? !_obscureText : _obscureText,

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
      onChanged: widget.onChanged,
    );
  }
}