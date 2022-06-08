import 'package:flutter/material.dart';

class ParameterWidget extends StatelessWidget {
  const ParameterWidget({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.numeral,
    required this.identifier,
  }) : super(key: key);
  final double screenWidth;
  final double screenHeight;
  final numeral;
  final String identifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: screenWidth / 9,
          height: screenWidth / 9,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              (numeral == "--") ? numeral : "${numeral.toInt()}",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        Text(
          identifier,
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            // // color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
