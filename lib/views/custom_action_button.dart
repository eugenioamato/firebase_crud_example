import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  const CustomActionButton(this.text, this.icon, this.func, this.isLoading);
  final String text;
  final IconData icon;
  final Function() func;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.amberAccent),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(child: Icon(icon)),
        Expanded(
          flex: 3,
          child: AutoSizeText(
            text,
            semanticsLabel: text,
            maxLines: 1,
          ),
        ),
      ]),
      onPressed: isLoading ? null : func,
    );
  }
}
