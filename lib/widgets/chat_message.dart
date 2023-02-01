import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final  AnimationController animationController;

  const ChatMessage({
    super.key, 
    required this.texto, 
    required this.uid, 
    required this.animationController,
    });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
        child: SizedBox(
          child: uid == '123' ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        margin: const EdgeInsets.only(
          bottom: 5,
          left: 50,
          right: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff4D9ef6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.only(
            bottom: 5,
            left: 8,
            right: 50,
          ),
          decoration: BoxDecoration(
              color: const Color(0xFFE4E5E8),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            texto,
            style: const TextStyle(color: Colors.black87),
          )),
    );
  }
}
