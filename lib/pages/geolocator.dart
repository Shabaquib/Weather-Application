import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinkit;
import 'package:intl/intl.dart';
import 'package:weather/data/countries_data.dart';

import '../themeData.dart';
import '../widgets/meridian_widget.dart';
import '../widgets/parameter_widget.dart';
import '../widgets/top_banner_widget.dart';

class GeoLocatorPage extends StatefulWidget {
  const GeoLocatorPage(
      {Key? key,
      required this.apiKey,
      required this.screenWidth,
      required this.screenHeight})
      : super(key: key);
  final String apiKey;
  final screenWidth;
  final screenHeight;

  @override
  State<GeoLocatorPage> createState() => _GeoLocatorPageState();
}

//Add no permission clause

class _GeoLocatorPageState extends State<GeoLocatorPage> {
  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return "Permission denied";
    } else {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      var apiUrl =
          "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${widget.apiKey}&units=metric";
      final response = await http.get(Uri.parse(apiUrl));

      print(convert.jsonDecode(response.body).runtimeType);

      return convert.jsonDecode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: repeater,
        builder: (aa, bb, cc) {
          if (!bb) {
            return FutureBuilder(
                future: getCurrentLocation(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    if (snapshot.data == "Permission denied") {
                      if (Theme.of(context).primaryColor ==
                          MaterialColor(0xFF00272B, darkColor)) {
                        return Scaffold(
                          appBar: AppBar(
                            title: const Text("Geolocator"),
                          ),
                          body: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                    "Assets/SvgAssets/APIKey_Error-Light.svg",
                                    width: widget.screenWidth / 5,
                                    height: widget.screenHeight / 5),
                                const SizedBox(height: 20.0),
                                Text(
                                  'Your phone has denied permissions',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Scaffold(
                          appBar: AppBar(
                            title: const Text("Geolocator"),
                          ),
                          body: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                    "Assets/SvgAssets/APIKey_Error-Dark.svg",
                                    width: widget.screenWidth / 5,
                                    height: widget.screenHeight / 5),
                                const SizedBox(height: 20.0),
                                Text(
                                  'Your phone has denied permissions',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      if (snapshot.data['cod'] == 200) {
                        return Scaffold(
                          appBar: AppBar(
                              title: Text(
                                  " ${snapshot.data['name'] ?? ""},${snapshot.data['sys']['country'] ?? ""}"),
                              elevation: 2.0),
                          body: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                TopBannerWidget(
                                  screenWidth: widget.screenWidth,
                                  screenHeight: widget.screenHeight,
                                  countryCode:
                                      snapshot.data['sys']['country'] ?? "",
                                  cityName: snapshot.data['name'] ?? "",
                                  coordinates: [
                                    snapshot.data['coord']['lon'],
                                    snapshot.data['coord']['lat']
                                  ],
                                  tempArg: snapshot.data['main']['temp'],
                                  backgroundCode: snapshot.data['weather'][0]
                                      ['icon'],
                                  dateArg: DateFormat("dd-MM-yyyy").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.data['dt'] * 1000,
                                  )),
                                  timeArg: DateFormat("hh:mm a").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          snapshot.data['dt'] * 1000)),
                                  backgroundHour:
                                      DateTime.fromMillisecondsSinceEpoch(
                                              snapshot.data['dt'] * 1000)
                                          .hour,
                                ),
                                SizedBox(
                                  height: widget.screenWidth / 20,
                                ),
                                SizedBox(
                                  width: widget.screenWidth,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                child: Icon(
                                                  Icons.thermostat,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: widget.screenWidth / 12,
                                                ),
                                              ),
                                              Positioned(
                                                right: 0.0,
                                                top: 0.0,
                                                child: Text(
                                                  "°C",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: widget.screenWidth / 9,
                                            child: FittedBox(
                                              child: Text(
                                                "(Temp)",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ParameterWidget(
                                          screenWidth: widget.screenWidth,
                                          screenHeight: widget.screenHeight,
                                          numeral: snapshot.data['main']
                                                  ['temp_min'] ??
                                              "--",
                                          identifier: "Min"),
                                      ParameterWidget(
                                          screenWidth: widget.screenWidth,
                                          screenHeight: widget.screenHeight,
                                          numeral: snapshot.data['main']
                                                  ['feels_like'] ??
                                              "--",
                                          identifier: "Temp"),
                                      ParameterWidget(
                                          screenWidth: widget.screenWidth,
                                          screenHeight: widget.screenHeight,
                                          numeral: snapshot.data['main']
                                                  ['temp_max'] ??
                                              "--",
                                          identifier: "Max"),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: widget.screenWidth / 12,
                                ),
                                SizedBox(
                                  width: widget.screenWidth,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                child: SvgPicture.asset(
                                                  "Assets/SvgAssets/barometer.svg",
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width:
                                                      widget.screenWidth / 14,
                                                  height:
                                                      widget.screenWidth / 14,
                                                ),
                                              ),
                                              Positioned(
                                                right: 0.0,
                                                top: 0.0,
                                                child: Text(
                                                  "hPa",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: widget.screenWidth / 9,
                                            child: FittedBox(
                                              child: Text(
                                                "Pressure",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ParameterWidget(
                                          screenWidth: widget.screenWidth,
                                          screenHeight: widget.screenHeight,
                                          numeral: snapshot.data['main']
                                                  ['sea_level'] ??
                                              "--",
                                          identifier: "Sea\nLevel"),
                                      ParameterWidget(
                                          screenWidth: widget.screenWidth,
                                          screenHeight: widget.screenHeight,
                                          numeral: snapshot.data['main']
                                                  ['pressure'] ??
                                              "--",
                                          identifier: "Feels\nLike"),
                                      ParameterWidget(
                                          screenWidth: widget.screenWidth,
                                          screenHeight: widget.screenHeight,
                                          numeral: snapshot.data['main']
                                                  ['grnd_level'] ??
                                              "--",
                                          identifier: "Ground\nLevel"),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: widget.screenWidth / 12,
                                ),
                                SizedBox(
                                  width: widget.screenWidth,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                child: SvgPicture.asset(
                                                  "Assets/SvgAssets/wind.svg",
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width:
                                                      widget.screenWidth / 14,
                                                  height:
                                                      widget.screenWidth / 14,
                                                ),
                                              ),
                                              Positioned(
                                                right: 0.0,
                                                top: 0.0,
                                                child: Text(
                                                  "--",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: widget.screenWidth / 9,
                                            child: FittedBox(
                                              child: Text(
                                                "(Wind)",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ParameterWidget(
                                          screenWidth: widget.screenWidth,
                                          screenHeight: widget.screenHeight,
                                          numeral: snapshot.data['wind']
                                                  ['speed'] ??
                                              "--",
                                          identifier: "Speed\n(m/s)"),
                                      ParameterWidget(
                                          screenWidth: widget.screenWidth,
                                          screenHeight: widget.screenHeight,
                                          numeral: snapshot.data['wind']
                                                  ['gust'] ??
                                              "--",
                                          identifier: "Gust\n(m/s)"),
                                      ParameterWidget(
                                          screenWidth: widget.screenWidth,
                                          screenHeight: widget.screenHeight,
                                          numeral: snapshot.data['wind']
                                                  ['deg'] ??
                                              "--",
                                          identifier: "Degree\n( ° )"),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: widget.screenWidth / 12,
                                ),
                                SizedBox(
                                  width: widget.screenWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      MeridianWidget(
                                          screenWidth: widget.screenWidth,
                                          iconName: "Sunrise",
                                          time: DateFormat("hh:mm a").format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      snapshot.data['sys']
                                                              ['sunrise'] *
                                                          1000))),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          SizedBox(
                                            width: widget.screenWidth / 8,
                                            child: Text(
                                              "${snapshot.data['main']['humidity'] ?? "--"}%",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: widget.screenWidth / 8,
                                            child: FittedBox(
                                              child: Text(
                                                "Humidity",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      MeridianWidget(
                                        screenWidth: widget.screenWidth,
                                        iconName: "Sunset",
                                        time: DateFormat("hh:mm a").format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                snapshot.data['sys']['sunset'] *
                                                    1000)),
                                      ),
                                    ],
                                  ),
                                ),
                                //snapshot.data['sys']['country'] ?? ""
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.data['cod'] == 404) {
                        return Scaffold(
                          appBar: AppBar(),
                          body: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "Assets/SvgAssets/404-Dark.svg",
                                  width: widget.screenWidth / 2.5,
                                  height: widget.screenWidth / 2.5,
                                ),
                                SizedBox(
                                  height: widget.screenHeight / 20,
                                ),
                                Text(
                                  "We couldn't find what you\n were asking for!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.data['cod'] == 401) {
                        return Scaffold(
                          appBar: AppBar(),
                          body: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "Assets/SvgAssets/APIKey_Error-Dark.svg",
                                  width: widget.screenWidth / 2.5,
                                  height: widget.screenWidth / 2.5,
                                ),
                                SizedBox(
                                  height: widget.screenHeight / 20,
                                ),
                                Text(
                                  "Make sure you have a correct API key!\nGo to Settings page and add it!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Scaffold(
                          appBar: AppBar(),
                          body: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "Assets/SvgAssets/404-Dark.svg",
                                  width: widget.screenWidth / 2.5,
                                  height: widget.screenWidth / 2.5,
                                ),
                                SizedBox(
                                  height: widget.screenHeight / 20,
                                ),
                                Text(
                                  "We couldn't find what you\n were asking for!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    return Scaffold(
                      appBar: AppBar(),
                      body: Center(
                        child: spinkit.SpinKitChasingDots(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  }
                });
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Geolocator"),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (Theme.of(context).primaryColor ==
                            MaterialColor(0xFFEFF1F3, lightColor))
                        ? SvgPicture.asset(
                            "Assets/SvgAssets/Disconnected-Dark.svg",
                            width: widget.screenWidth / 2.5,
                            height: widget.screenWidth / 2.5,
                          )
                        : SvgPicture.asset(
                            "Assets/SvgAssets/Disconnected-Light.svg",
                            width: widget.screenWidth / 2.5,
                            height: widget.screenWidth / 2.5,
                          ),
                    SizedBox(
                      height: widget.screenHeight / 20,
                    ),
                    Text(
                      "Check your data connection",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
