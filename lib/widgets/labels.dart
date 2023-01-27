import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String labelText1;
  final String labelText2;
  const Labels({super.key, required this.ruta, required this.labelText1, required this.labelText2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(labelText1,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w300)),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: (() => {
            Navigator.pushReplacementNamed(context, ruta),
          }),
          child: Text(
            labelText2,
            style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
