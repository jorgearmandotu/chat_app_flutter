import 'package:chat/helpers/mostrar_alert.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/button_azul.dart';
import 'package:flutter/material.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.94,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  <Widget>[
                      Logo(title: 'Messenger',),
                      _Form(),
                      Labels( ruta: 'register', labelText1: '¿No tienes cuenta?', labelText2: 'Crea una ahora!'),
                      Text(
                        'Términos y condiciones de uso',
                        style: TextStyle(fontWeight: FontWeight.w200),
                      )
                    ],
                  ),
                ),
              ]),
        ));
  }
}

class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),

          ButtonAzul(
            text: 'Login',
            onPressed: authService.autenticando ? null: () async {

              FocusScope.of(context).unfocus();
              final loginOk = await authService.login( emailCtrl.text.trim(), passCtrl.text.trim() );
           
              if(loginOk  && mounted ){
                // TODO COnectar a nuestra socket server
                Navigator.pushReplacementNamed(context, 'usuarios');
              }else{
                // Mostrar alerta
                mostrarAlerta( context, 'Login Incorrecto', 'Revise sus credenciales de acceso.');
              }
              },
          )
        ],
      ),
    );
  }
}
