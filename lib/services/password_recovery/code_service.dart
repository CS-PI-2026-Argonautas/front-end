import 'dart:math';

class CodeService {
  String? _code;
  DateTime? _expiration;

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

  bool validateCode(String value){
    if(_code == null || _expiration == null) return false;

    if(DateTime.now().isAfter(_expiration!)) return false;

    return value == _code ? true : false;
  }

  String? get code => _code;
  DateTime? get expiration => _expiration;

}

