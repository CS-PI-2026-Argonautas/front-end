import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/pages/password_recovery/reset_password.dart';
import 'package:frontend/utils/password_recovery/validators.dart';

class UserInformation extends StatefulWidget{

  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();

}

class _UserInformationState extends State<UserInformation>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: Text('Recuperar Senha'),
      ),
        body: SafeArea(
          child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Para redefinição de sua senha, informe seu nome de usuário e enviaremos um código para redefinir sua senha.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 80,),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome de Usuário',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(

                        validator: (value) => requiredField(value),
                        
                        decoration: InputDecoration(
                          hintText: 'Digite seu nome de usuário...',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
                
                Spacer(),

                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 6,),
                      SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()){
                          
                          final choice = await showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: 'Confirmação de e-mail',
                            pageBuilder: (_, __, ___, ){
                              return Stack(
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ),

                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(24),
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Este é seu e-mail? ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'email****@ex***.com',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          SizedBox(height: 24,),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: FilledButton(
                                                  style: FilledButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(vertical: 16),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadiusGeometry.circular(12),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                  child: Text(
                                                    'Sim',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 24,),

                                              Expanded(
                                                child: FilledButton(
                                                  style: FilledButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(vertical: 16),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadiusGeometry.circular(12),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context, false);
                                                  },
                                                  child: Text(
                                                    'Não',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              );

                              
                            },
                          );

                          if(choice == true){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResetPassword(),
                              ),
                            );
                          }   

                        }

                      },
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Prosseguir',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 6,),

                    ],
                  ),
                  
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}

/* 

🧭 📦 VISÃO GERAL DA ESTRUTURA

Você vai ter basicamente:

/screens
  user_information.dart   (Tela 1)
  reset_password.dart     (Tela 2)

/services (ou dentro da State por enquanto)
  auth_mock.dart          (simulação lógica)

/utils
  code_utils.dart         (opcional)

Se quiser simples (sem pastas extras), tudo pode ficar dentro dos StatefulWidgets.

🧱 1. Fake “banco de dados”

📍 Onde fica: fora da classe da tela 1 (topo do arquivo)

const fakeUser = {
  'username': 'usuario123',
  'email': 'usuario123@gmail.com',
};

👉 Isso simula seu backend.

🧠 2. Estado global da lógica do código

📍 Onde fica: dentro da State da tela 1 (ou depois mover pra service)

String? generatedCode;
DateTime? codeExpiration;
🔐 3. Gerar código + expiração

📍 Onde fica: dentro da State (tela 1 ou service)

import 'dart:math';

String generateCode() {
  final random = Random();
  return (100000 + random.nextInt(900000)).toString();
}

void createCode() {
  generatedCode = generateCode();
  codeExpiration = DateTime.now().add(Duration(minutes: 5));
}

👉 Isso deve ser chamado quando o usuário clica “Sim” no modal.

📩 4. “Envio de e-mail” (mock)

📍 Onde fica: logo após createCode()

void sendEmailMock(String email) {
  print("Código enviado para $email: $generatedCode");
}

👉 Aqui você também pode usar SnackBar.

🧾 5. Mascarar e-mail

📍 Onde fica: utilitário (ou dentro da tela 1)

String maskEmail(String email) {
  final parts = email.split('@');

  final name = parts[0];
  final domain = parts[1];

  return '${name.substring(0, 3)}******@${domain.substring(0, 2)}*****';
}

👉 Usado no MODAL da tela 1.

🔁 6. Fluxo entre telas

📍 Onde fica: botão “Sim” do modal

onPressed: () {
  createCode();
  sendEmailMock(fakeUser['email']!);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ResetPasswordScreen(),
    ),
  );
}
📱 7. Tela 2 (UI separada)

📍 Arquivo novo: reset_password.dart

Aqui entra:

campo código
senha
confirmar senha

👉 Essa tela DEPENDE do generatedCode e codeExpiration

⏱️ 8. Validar código

📍 Tela 2 (State)

bool isCodeValid(String input) {
  if (generatedCode == null || codeExpiration == null) return false;

  if (DateTime.now().isAfter(codeExpiration!)) {
    return false;
  }

  return input == generatedCode;
}
✔️❌ 9. Feedback visual

📍 Dentro do TextField do código (Tela 2)

onChanged: (value) {
  setState(() {
    isValid = isCodeValid(value);
  });
}

UI:

Icon(
  isValid == null
      ? null
      : isValid!
          ? Icons.check
          : Icons.close,
  color: isValid == true ? Colors.green : Colors.red,
)
🔒 10. Bloquear senha se código inválido

📍 Tela 2

bool canEditPassword = isValid == true;
TextFormField(
  enabled: canEditPassword,
)
🔁 11. Validar senhas iguais

📍 Form validator da Tela 2

validator: (value) {
  if (value != passwordController.text) {
    return 'As senhas não coincidem';
  }
  return null;
}
🆘 12. Link de suporte

📍 Em ambas as telas (rodapé)

TextButton(
  onPressed: () {},
  child: Text('Precisa de ajuda? Contate o suporte'),
)
🧠 RESUMO INTELIGENTE
📍 Tela 1 (UserInformation)

Responsável por:

username
validar usuário fake
mostrar modal
gerar código
iniciar fluxo
📍 “Backend fake” (mesma tela ou service)
fakeUser
generateCode
expiration
sendEmailMock
📍 Tela 2 (ResetPassword)

Responsável por:

validar código
mostrar ✔️❌
bloquear senha
confirmar senha
finalizar reset





*/
