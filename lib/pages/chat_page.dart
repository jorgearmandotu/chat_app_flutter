import 'package:flutter/material.dart';

@immutable
class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('chat page'),
     ),
   );
  }
}