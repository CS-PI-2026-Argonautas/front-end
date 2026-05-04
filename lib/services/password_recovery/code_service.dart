import 'dart:math';

class CodeService {
  String? _code;
  DateTime? _expiration;
  bool _valid = false;

  String generateCode(){
    Random random = Random();
    return(100000 + random.nextInt(900000)).toString();
  }

  void createCode(){
    _code = generateCode();
    _expiration = DateTime.now().add(Duration(minutes: 5));

    print("CODE GERADO: $_code");
    print("EXPIRA EM: $_expiration");
  }

  String? validateCode(String value){
    if(_code == null || _expiration == null) return 'Nenhum código foi gerado';

    if(!_valid && DateTime.now().isAfter(_expiration!)) return 'Código expirado. Clique em \'Reenviar\'';

    if(value != _code) return 'Código incorreto';

    _valid = true;
    return null;
  }

  void invalidate(){
    _code = null;
    _expiration = null;
  }


  String? get code => _code;
  DateTime? get expiration => _expiration;

}

