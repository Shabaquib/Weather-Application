import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeridianWidget extends StatelessWidget {
  const MeridianWidget(
      {Key? key,
      required this.screenWidth,
      required this.iconName,
      required this.time})
      : super(key: key);
  final double screenWidth;
  final String iconName;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SvgPicture.asset(
          "Assets/SvgAssets/$iconName.svg",
          color: Theme.of(context).primaryColor,
        ),
        Text(
          iconName,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        SizedBox(
          width: screenWidth / 4,
          child: FittedBox(
            child: Text(
              time,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
