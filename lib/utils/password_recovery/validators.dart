String? requiredField(String? value) {
  if(value == null || value.trim().isEmpty) return 'Campo obrigatório';
  return null;
}

String? passwordValidator(String? value, {String? comparisonValue, String? nameComparisonValue = "ao valor de comparação"}){
  if(value == null || value.trim().isEmpty) return 'Campo obrigatório';
  
  if(value.length < 8) return 'A senha deve ter no mínimo 8 caracteres';

  if(value == comparisonValue) return 'A senha não pode ser igual ${nameComparisonValue}';

  return null;
}

String? confirmPassword (String? value, String originalPassword, {String? comparisonValue, String? nameComparisonValue = "ao valor de comparação"}){
  if(value == null || value.trim().isEmpty) return 'Campo obrigatório';

  if(value != originalPassword) return 'As senhas não coincidem';
  
  if(value == comparisonValue) return 'A senha não pode ser igual ${nameComparisonValue}';


  return null;
}

String? codeFormatValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Campo obrigatório';
  }

  if (value.length != 6) {
    return 'O código deve ter 6 dígitos';
  }

  return null;
}
