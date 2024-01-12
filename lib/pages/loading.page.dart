import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/usuarios_page.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/auth_service.dart';


class LoadingPage extends StatelessWidget {
const LoadingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
           return const Center(
            child: Text('Espere...'),
           );
        },
      ),
   );
  }

  Future checkLoginState( BuildContext context) async {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final autenticado = await authService.isLoggedIn(); 

    if( autenticado == true && context.mounted ){
      socketService.connect();
      // Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___) => const UsuariosPage(),
          transitionDuration: const Duration(milliseconds: 0)
        )
        );
    }else{
      if(context.mounted){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: ( _, __, ___) => const LoginPage(),
          transitionDuration: const Duration(milliseconds: 0)
        )
        );
      Navigator.pushReplacementNamed(context, 'login');
      }else {return;}
    }
  }
}