import 'package:flutter/material.dart';
import 'package:frontend/services/password_recovery/code_service.dart';
import 'package:frontend/utils/password_recovery/validators.dart';
import 'package:frontend/widgets/password_recovery/digitation_text_field.dart';


class ResetPassword extends StatefulWidget{

  final CodeService codeService;

  const ResetPassword({
    super.key,
    required this.codeService,});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>{

  bool? isCodeValid;
  bool canResend = true;

  bool validateCodeField = false;

  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _clearFields(){
    codeController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    setState(() {
      isCodeValid = null;
      validateCodeField = false;
    });

  }

  @override
  void dispose(){
    codeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recuperar Senha',
        ),
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
                    'Um e-mail com o código para redefinição da senha foi enviado para você. Caso este e-mail não chegue, verifique sua caixa de spam ou reenvie o código.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 24,),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Código',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(

                        controller: codeController,

                        autovalidateMode: validateCodeField ? 
                        AutovalidateMode.onUserInteraction : 
                        AutovalidateMode.disabled,

                        validator: (value) {
                          final formatError = codeFormatValidator(value);
                          if(formatError != null) return formatError;

                          return widget.codeService.validateCode(value!);
                        },

                        onChanged: (value) {

                          final error = widget.codeService.validateCode(value);

                          setState(() {
                            validateCodeField = true;
                            isCodeValid = (error == null);
                          });
                        },

                        decoration: InputDecoration(
                          hintText: 'Informe o código enviado...',

                          suffixIcon: isCodeValid == null ? null : Icon(
                            isCodeValid! ? Icons.check : Icons.close,
                            color: isCodeValid! ? Colors.green : Colors.red,
                          ),
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

                SizedBox(height: 18,),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nova senha',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      DigitationTextField(
                        controller: passwordController,
                        enabled: isCodeValid == true,
                        validator: (value) => passwordValidator(value),
                        hintText: 'Informe a nova senha...',
                        sensitiveContent: true,
                        isPassword: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 18,),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Repita a senha',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      DigitationTextField(
                        controller: confirmPasswordController,
                        enabled: isCodeValid == true,
                        validator: (value) => confirmPassword(value, passwordController.text),
                        hintText: 'Repita a nova senha...',
                        sensitiveContent: true,
                        isPassword: true,
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
                          onPressed: 
                          canResend 
                          ? 
                          () {
                            _clearFields();

                            widget.codeService.invalidate();

                            widget.codeService.createCode();

                            setState(() {
                              isCodeValid = null;
                              canResend = false;
                            });

                            print("REENVIADO: ${widget.codeService.code}");

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Código Gerado: ${widget.codeService.code}'),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );

                            

                            Future.delayed(
                              Duration(seconds: 30), () {
                                setState(() {
                                  canResend = true;
                                });
                              }
                            );
                          }
                          : 
                          null,
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Reenviar Código',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12,),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: FilledButton(
                          onPressed: isCodeValid == true 
                          ? 
                          () {
                            if (_formKey.currentState!.validate()) {
                              print('senha alterada');
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Senha alterada com sucesso!'),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                              _clearFields();
                              widget.codeService.invalidate();
                            }

                            else{
                              print('Não foi possível alterar sua senha');
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Não foi possível alterar a senha!'),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );

                              setState(() {
                                if(!canResend) canResend = true;
                              });
                            }

                          } 
                          : 
                          null,
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Alterar Senha',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 6,),

                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Dúvidas? Contate nosso suporte',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
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