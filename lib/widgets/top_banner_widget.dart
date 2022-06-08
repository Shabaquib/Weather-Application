import 'package:flutter/material.dart';

class TopBannerWidget extends StatefulWidget {
  const TopBannerWidget(
      {Key? key,
      required this.screenWidth,
      required this.screenHeight,
      required this.countryCode,
      required this.cityName,
      required this.coordinates,
      required this.tempArg,
      required this.backgroundCode,
      required this.dateArg,
      required this.timeArg,
      required this.backgroundHour})
      : super(key: key);
  final double screenWidth;
  final double screenHeight;
  final String countryCode;
  final String cityName;
  final List coordinates;
  final tempArg;
  final backgroundCode;
  final String dateArg;
  final String timeArg;
  final backgroundHour;

  @override
  State<TopBannerWidget> createState() => _TopBannerWidgetState();
}

class _TopBannerWidgetState extends State<TopBannerWidget> {
  returningTheBackground(code, arg2) {
    if (code == 200 ||
        code == 201 ||
        code == 202 ||
        code == 210 ||
        code == 211 ||
        code == 212 ||
        code == 221 ||
        code == 230 ||
        code == 231 ||
        code == 232) {
      if (widget.backgroundHour < 18 && widget.backgroundHour > 4) {
        return "Thunderstorm - Day";
      } else {
        return "Thunderstorm - Night";
      }
    } else if (code == 300 ||
        code == 301 ||
        code == 302 ||
        code == 310 ||
        code == 311 ||
        code == 312 ||
        code == 313 ||
        code == 314 ||
        code == 321) {
      if (widget.backgroundHour < 18 && widget.backgroundHour > 4) {
        return "Shower - Day";
      } else {
        return "Shower - Night";
      }
    } else if (code == 500 ||
        code == 501 ||
        code == 502 ||
        code == 503 ||
        code == 504 ||
        code == 511 ||
        code == 520 ||
        code == 521 ||
        code == 522 ||
        code == 531) {
      if (widget.backgroundHour < 18 && widget.backgroundHour > 4) {
        return "Rain - Day";
      } else {
        return "Rain - Night";
      }
    } else if (code == 600 ||
        code == 601 ||
        code == 602 ||
        code == 611 ||
        code == 612 ||
        code == 613 ||
        code == 615 ||
        code == 616 ||
        code == 620 ||
        code == 621 ||
        code == 622) {
      if (widget.backgroundHour < 18 && widget.backgroundHour > 4) {
        return "Snow - Day";
      } else {
        return "Snow - Night";
      }
    } else if (code == 711 ||
        code == 721 ||
        code == 751 ||
        code == 761 ||
        code == 701) {
      if (widget.backgroundHour < 18 && widget.backgroundHour > 4) {
        return "Mist - Day";
      } else {
        return "Mist - Night";
      }
    } else if (code == 741) {
      if (widget.backgroundHour < 18 && widget.backgroundHour > 4) {
        return "Fog - Day";
      } else {
        return "Fog - Night";
      }
    } else if (code == 800) {
      if (widget.backgroundHour < 18 && widget.backgroundHour > 4) {
        return "Clear Sky - Day";
      } else {
        return "Clear Sky - Night";
      }
    } else if (code == 801 || code == 802 || code == 803 || code == 804) {
      if (widget.backgroundHour < 18 && widget.backgroundHour > 4) {
        return "Cloudy - Day";
      } else {
        return "Cloudy - Night";
      }
    } else {
      if (widget.backgroundHour < 18 && widget.backgroundHour > 4) {
        return "Clear Sky - Day";
      } else {
        return "Clear Sky - Night";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.screenWidth,
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Container(
              width: widget.screenWidth * 0.9,
              height: 170,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'Assets/ImageAssets/${returningTheBackground(widget.backgroundCode, widget.timeArg)}.jpg',
                fit: BoxFit.cover,
                cacheWidth: (widget.screenWidth * 0.9).truncate(),
              ),
            ),
            Container(
              width: widget.screenWidth * 0.9,
              height: 170,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              foregroundDecoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.2),
                      Color.fromRGBO(0, 0, 0, 0.4)
                    ]),
              ),
            ),
            Container(
              width: widget.screenWidth * 0.9,
              height: widget.screenHeight / 5,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.only(top: 15.0, right: 20.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    widget.timeArg,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
            Container(
              width: widget.screenWidth * 0.9,
              height: widget.screenHeight / 5,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.only(top: 15.0, left: 20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.dateArg,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: widget.screenWidth * 0.9,
              height: widget.screenHeight / 5,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.only(bottom: 10.0, left: 10.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                    ),
                    Text(
                      "${widget.countryCode}, ${widget.cityName}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: widget.screenWidth * 0.9,
              height: widget.screenHeight / 5,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "(${widget.coordinates[0].toInt()}, ${widget.coordinates[1].toInt()})",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: widget.screenWidth * 0.9,
              height: widget.screenHeight / 5,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // GestureDetector(
                    //   child: Container(
                    //     margin: const EdgeInsets.only(right: 30.0),
                    //     child: const Icon(
                    //       Icons.arrow_left_rounded,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "${widget.tempArg.toInt()}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.screenHeight / 20,
                          ),
                        ),
                        const Text(
                          "(Celsius)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    // GestureDetector(
                    //   child: Container(
                    //     margin: const EdgeInsets.only(left: 30.0),
                    //     child: const Icon(
                    //       Icons.arrow_right_rounded,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
