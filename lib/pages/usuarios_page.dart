import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat/models/usuario.dart';


class UsuariosPage extends StatefulWidget {
  UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(online: true, email: 'test@test.com', nombre: 'Maria', uid: '1'),
    Usuario(online: false, email: 'test1@test.com', nombre: 'Emma', uid: '2'),
    Usuario(online: true, email: 'test2@test.com', nombre: 'Daniela', uid: '3'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi nombre', style: TextStyle(color: Colors.black87),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black87,),
          onPressed: () {},
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle_outline, color: Colors.blue[400],),
            //child: Icon(Icons.offline_bolt_outlined, color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        //enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropMaterialHeader(
          // complete: Icon(Icons.check_circle_outline, color: Colors.blue[400], size: 50,),
          // refresh: CircularProgressIndicator(
          //   color: Colors.blue[400],
          //   backgroundColor: Colors.grey[400],
          // ),
          // waterDropColor: Colors.blue.shade400,
          backgroundColor: Colors.blue.shade400,
          ),
        child: _listViewUsuarios(),
        )
   );
  }
 
  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: ( _ , i) => _usuarioListTile(usuarios[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: usuarios.length,
   );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child:  Text(usuario.nombre.substring(0,2)),
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      );
  }

 Future _cargarUsuarios() async{
  await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
}

}