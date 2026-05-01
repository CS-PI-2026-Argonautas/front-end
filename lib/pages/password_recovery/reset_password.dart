import 'package:flutter/material.dart';
import 'package:frontend/services/password_recovery/code_service.dart';
import 'package:frontend/utils/password_recovery/validators.dart';

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

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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

                        validator: (value) => codeFormatValidator(value),

                        onChanged: (value) {
                          setState(() {
                            isCodeValid = widget.codeService.validateCode(value);
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
                      TextFormField(
                        controller: passwordController,

                        enabled: isCodeValid == true,

                        validator: (value) => passwordValidator(value),

                        decoration: InputDecoration(
                          hintText: 'Informe a nova senha...',
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
                        'Repita a senha',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        controller: confirmPasswordController,

                        enabled: isCodeValid == true,

                        validator: (value) => confirmPassword(value, passwordController.text),

                        decoration: InputDecoration(
                          hintText: 'Repita a nova senha...',
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
                          onPressed: () {},
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