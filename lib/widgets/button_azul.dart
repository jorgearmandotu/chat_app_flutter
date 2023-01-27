import 'package:flutter/material.dart';

class ButtonAzul extends StatelessWidget {
  const ButtonAzul({
    super.key, 
    required this.text, 
    this.onPressed
    });
  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            onPressed: onPressed,//() => {print(emailCtrl.text), print(passCtrl.text)},
            style: ElevatedButton.styleFrom(
              elevation: 2,
              backgroundColor: Colors.blue,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(text, style:const TextStyle(color: Colors.white, fontSize: 17),),
              ),
            ),
          );
  }
}