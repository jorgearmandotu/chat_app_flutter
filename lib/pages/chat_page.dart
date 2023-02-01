import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat/widgets/chat_message.dart';

@immutable
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatMessage>  _messages = [];
  bool _writing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              maxRadius: 14,
              child: const Text(
                'EU',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            const Text(
              'Emma Urbina',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
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

            //TODO: caja de texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
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

    final newMessage = ChatMessage(texto: text, uid: '123', animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 1000)),);
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _writing = false;
    });
  }

  @override
  void dispose() {
    // TODO: off del socket
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}
