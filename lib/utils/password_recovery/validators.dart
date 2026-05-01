String? requiredField(String? value) {
  if(value == null || value.trim().isEmpty) return 'Campo obrigatório';
  return null;
}

String? passwordValidator(String? value){
  if(value == null || value.trim().isEmpty) return 'Campo obrigatório';
  
  if(value.length < 6) return 'A senha deve ter no mínimo 6 caracteres';

  return null;
}

String? confirmPassword (String? value, String originalPassword){
  if(value == null || value.trim().isEmpty) return 'Campo obrigatório';

  if(value != originalPassword) return 'As senhas não coincidem';

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