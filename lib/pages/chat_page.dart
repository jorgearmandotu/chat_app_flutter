import 'dart:io';
import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat/services/chat_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:provider/provider.dart';

@immutable
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  ChatService? chatService;
  SocketService? socketService;
  AuthService? authService;

  final List<ChatMessage>  _messages = [];
  bool _writing = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context,listen: false);
    socketService = Provider.of<SocketService>(context,listen: false);
    authService = Provider.of<AuthService>(context,listen: false);

    socketService?.socket.on(
      'mensaje-personal', _escucharMensaje
      );
    
    _cargarHistorial(chatService!.usuarioPara!.uid);
  }

  void _cargarHistorial( String? usuarioID) async{
     List<Mensaje> chat = await chatService!.getChat(usuarioID);
     
     final history = chat.map((m) => ChatMessage(
      texto: m.mensaje, 
      uid: m.de,
      animationController: AnimationController(vsync: this, duration: const Duration( milliseconds: 0))..forward(),
      ));

      setState(() {
        _messages.insertAll(0, history);
      });
  }

  void _escucharMensaje( dynamic payload ) {
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController( vsync: this, duration: const Duration(milliseconds: 300)),);

      setState(() {
        _messages.insert(0, message);
      });

      message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {


    final usuarioPara = chatService?.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              maxRadius: 14,
              child: Text(  
                usuarioPara?.nombre.substring(0, 2) ?? '',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              usuarioPara?.nombre ?? '',
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
              //itemExtent: 30,
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),
            const Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(children: <Widget>[
        Flexible(
            child: TextField(
          controller: _textController,
          onSubmitted: _handleSubmit,
          onChanged: (String texto) {
            setState(() {
              if (texto.trim().isNotEmpty) {
                _writing = true;
              } else {
                _writing = false;
              }
            });
          },
          decoration:
              const InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
          focusNode: _focusNode,
        )),
        //Boton enviar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Platform.isIOS
              ? CupertinoButton(
                  onPressed: _writing
                      ? () => _handleSubmit(_textController.text.trim())
                      : null,
                  child: _writing
                      ? Text('Enviar',
                          style: TextStyle(color: Colors.blue.shade400))
                      : const Text('Enviar'))
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.blue.shade400),
                    child: IconButton(
                        //highlightColor: Colors.transparent,
                        onPressed: _writing
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                        icon: const Icon(Icons.send_outlined)),
                  ),
                ),
        ),
      ]),
    ));
  }

  _handleSubmit(String text) {
    if(text.isEmpty ) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: text, 
      uid: authService!.usuario!.uid, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 1000)),);
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _writing = false;
    });
    socketService?.emit('mensaje-personal', {
      'de' : authService?.usuario?.uid,
      'para' : chatService?.usuarioPara?.uid,
      'mensaje' : text,
    });
  }

  @override
  void dispose() {
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
    socketService?.socket.off('mensaje-personal');
    super.dispose();
  }
}
