import "package:flutter/material.dart";
import "package:zxcvbn/zxcvbn.dart";

class PasswordStrength {
  final _zxcvbn = Zxcvbn();

  String passwordStrengthText(int passwordScore){
    if(passwordScore <= 1) return "Fraca";
    if(passwordScore <= 3) return "Média";
    return "Forte";
  }

  Color passwordStrengthColor(int passwordScore){
    if(passwordScore <= 1) return Colors.red;
    if(passwordScore <= 2) return Colors.amber;
    return Colors.green;
  }


  Zxcvbn get zxcvbn => _zxcvbn;
}