// use este validador para verificar se um campo obrigatorio foi preenchido, passando requiredValidator no validator do campo
String? requiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Campo obrigatório';
  }
  return null;
}