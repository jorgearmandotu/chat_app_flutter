import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/helpers/mostrar_alert.dart';

import 'package:chat/services/socket_service.dart';
import 'package:chat/services/auth_service.dart';

import 'package:chat/widgets/button_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
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
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children:  <Widget>[
                      Logo(title: 'Registro',),
                      _Form(),
                      Labels( ruta: 'login', labelText1: '¿Ya tienes una cuenta?', labelText2: 'Ingresa ahora!',),
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
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.person_outline,
            placeholder: 'Nombre',
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),

          ButtonAzul(
            text: 'Registrar',
            onPressed: authService.autenticando ? ()=>{} : () async {
              final registroOk = await authService.register(
                nameCtrl.text.trim(), 
                emailCtrl.text.trim(), 
                passCtrl.text.trim() );
                
              if( !mounted ) return;
              if( registroOk == true) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              }else {
                mostrarAlerta(context, 'Fallo al registrar ', registroOk );
              }
              },
          )
        ],
      ),
    );
  }
}
