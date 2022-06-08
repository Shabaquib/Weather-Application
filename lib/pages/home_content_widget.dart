import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinkit;

import '../data/countries_data.dart';
import '../storage/save_data.dart';
import '../themeData.dart';
import '../widgets/meridian_widget.dart';
import '../widgets/parameter_widget.dart';
import '../widgets/top_banner_widget.dart';

refreshSrvice(String arg) {
  label.value = arg;
}

class HomePageWidget extends StatefulWidget {
  HomePageWidget(
      {Key? key,
      required this.screenWidth,
      required this.screenHeight,
      required this.dirPath,
      required this.box,
      required this.apiKey})
      : super(key: key);
  final double screenWidth;
  final double screenHeight;
  final String dirPath;
  final Box<SavedList> box;
  final String apiKey;

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  FixedExtentScrollController scrollController =
      FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollPhysics physics = const FixedExtentScrollPhysics();

  //selected integer value in ListWheel view
  int selected = 0;
  //contains the name of the country selected
  String name = "";
  //contains also the name of the country selected
  String selectedCountry = "";
  //contains also the name of the city selected
  String selectedCity = "";
  //to contain the names of the countries saved so that flags may be used
  List<String> flagsList = [];

  //returning Date
  Date(DateTime arg) {
    String minuteArg = (arg.minute > 9) ? "${arg.minute}" : "0${arg.minute}";
    String timeArg = (arg.hour > 12)
        ? "${arg.hour - 12}:$minuteArg ${(arg.hour > 12) ? "PM" : "AM"}"
        : "0${arg.hour}:$minuteArg ${(arg.hour > 12) ? "PM" : "AM"}";
    return timeArg;
  }

  // A demo API call by now
  //Put a check for no data!
  Future gettingAPI(String arg1, String arg2) async {
    var temp = "${arg1.replaceAll(" ", "+")},$arg2";
    var apiURL =
        "http://api.openweathermap.org/data/2.5/weather?q=${temp}&appid=${widget.apiKey}&units=metric";
    print(apiURL);
    final response = await http.get(Uri.parse(apiURL));
    print(response);
    var data = jsonDecode(response.body);
    print(data);
    return data;
  }

  //children of the ListWheelScrollView
  AnimatedContainerBuilder(int index, Box<SavedList> box) {
    print("Animated Container child $index");
    return AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: math.pi / 2,
              child: Text(
                index == selected
                    ? countriesIso[(box.getAt(index) as SavedList).countryName]!
                    : " ",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(
              width: index == selected ? 10.0 : 0,
            ),
            CircleAvatar(
                radius: index == selected
                    ? widget.screenWidth / 14
                    : widget.screenWidth / 20,
                child: Transform.rotate(
                  angle: math.pi / 2,
                  child: SvgPicture.asset(
                      (box.getAt(index) as SavedList).flagPath),
                )),
          ],
        ),
        onEnd: () {
          print("I think It's created already!");
        });
  }

  returningCountry(Box box, String b) {
    return (selectedCountry.isEmpty)
        ? (b.isEmpty)
            ? countriesIso[(box.getAt(0) as SavedList).countryName]!
            : countriesIso[b.split(',')[0]]!
        : selectedCountry;
  }

  returningCity(Box box, String b) {
    return (selectedCity.isEmpty)
        ? (b.isEmpty)
            ? (box.getAt(0) as SavedList).cityName
            : b.split(',')[1]
        : selectedCity;
  }

  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
        box: widget.box,
        builder: (context, box) {
          if (box.length > 0) {
            return Stack(
              children: <Widget>[
                ValueListenableBuilder<String>(
                    valueListenable: label,
                    builder: (a, b, c) {
                      return ValueListenableBuilder<bool>(
                          valueListenable: repeater,
                          builder: (aa, bb, cc) {
                            if (!bb) {
                              return FutureBuilder(
                                  future: gettingAPI(returningCity(box, b),
                                      returningCountry(box, b)),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      if (snapshot.data['cod'] == 200) {
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: <Widget>[
                                              TopBannerWidget(
                                                screenWidth: widget.screenWidth,
                                                screenHeight:
                                                    widget.screenHeight,
                                                countryCode: returningCountry(
                                                    widget.box, b),
                                                cityName: returningCity(
                                                    widget.box, b),
                                                coordinates: [
                                                  snapshot.data['coord']['lon'],
                                                  snapshot.data['coord']['lat']
                                                ],
                                                tempArg: snapshot.data['main']
                                                    ['temp'],
                                                backgroundCode: snapshot
                                                    .data['weather'][0]['id'],
                                                dateArg: DateFormat(
                                                        "dd-MM-yyyy")
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                  snapshot.data['dt'] * 1000,
                                                )),
                                                timeArg: DateFormat("hh:mm a")
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            snapshot.data[
                                                                    'dt'] *
                                                                1000)),
                                                backgroundHour: DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            snapshot.data[
                                                                    'dt'] *
                                                                1000)
                                                    .hour,
                                              ),
                                              SizedBox(
                                                height: widget.screenWidth / 20,
                                              ),
                                              SizedBox(
                                                width: widget.screenWidth,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Stack(
                                                          children: <Widget>[
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Icon(
                                                                Icons
                                                                    .thermostat,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: widget
                                                                        .screenWidth /
                                                                    12,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              right: 0.0,
                                                              top: 0.0,
                                                              child: Text(
                                                                "°C",
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: widget
                                                                  .screenWidth /
                                                              9,
                                                          child: FittedBox(
                                                            child: Text(
                                                              "(Temp)",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    ParameterWidget(
                                                        screenWidth:
                                                            widget.screenWidth,
                                                        screenHeight:
                                                            widget.screenHeight,
                                                        numeral: snapshot.data[
                                                                    'main']
                                                                ['temp_min'] ??
                                                            "--",
                                                        identifier: "Min"),
                                                    ParameterWidget(
                                                        screenWidth:
                                                            widget.screenWidth,
                                                        screenHeight:
                                                            widget.screenHeight,
                                                        numeral: snapshot.data[
                                                                    'main'][
                                                                'feels_like'] ??
                                                            "--",
                                                        identifier: "Temp"),
                                                    ParameterWidget(
                                                        screenWidth:
                                                            widget.screenWidth,
                                                        screenHeight:
                                                            widget.screenHeight,
                                                        numeral: snapshot.data[
                                                                    'main']
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Stack(
                                                          children: <Widget>[
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                "Assets/SvgAssets/barometer.svg",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                width: widget
                                                                        .screenWidth /
                                                                    14,
                                                                height: widget
                                                                        .screenWidth /
                                                                    14,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              right: 0.0,
                                                              top: 0.0,
                                                              child: Text(
                                                                "hPa",
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: widget
                                                                  .screenWidth /
                                                              9,
                                                          child: FittedBox(
                                                            child: Text(
                                                              "Pressure",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    ParameterWidget(
                                                        screenWidth:
                                                            widget.screenWidth,
                                                        screenHeight:
                                                            widget.screenHeight,
                                                        numeral: snapshot.data[
                                                                    'main']
                                                                ['sea_level'] ??
                                                            "--",
                                                        identifier:
                                                            "Sea\nLevel"),
                                                    ParameterWidget(
                                                        screenWidth:
                                                            widget.screenWidth,
                                                        screenHeight:
                                                            widget.screenHeight,
                                                        numeral: snapshot.data[
                                                                    'main']
                                                                ['pressure'] ??
                                                            "--",
                                                        identifier:
                                                            "Feels\nLike"),
                                                    ParameterWidget(
                                                        screenWidth:
                                                            widget.screenWidth,
                                                        screenHeight:
                                                            widget.screenHeight,
                                                        numeral: snapshot.data[
                                                                    'main'][
                                                                'grnd_level'] ??
                                                            "--",
                                                        identifier:
                                                            "Ground\nLevel"),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: widget.screenWidth / 12,
                                              ),
                                              SizedBox(
                                                width: widget.screenWidth,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Stack(
                                                          children: <Widget>[
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                "Assets/SvgAssets/wind.svg",
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                width: widget
                                                                        .screenWidth /
                                                                    14,
                                                                height: widget
                                                                        .screenWidth /
                                                                    14,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              right: 0.0,
                                                              top: 0.0,
                                                              child: Text(
                                                                "--",
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: widget
                                                                  .screenWidth /
                                                              9,
                                                          child: FittedBox(
                                                            child: Text(
                                                              "(Wind)",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    ParameterWidget(
                                                        screenWidth:
                                                            widget.screenWidth,
                                                        screenHeight:
                                                            widget.screenHeight,
                                                        numeral: snapshot.data[
                                                                    'wind']
                                                                ['speed'] ??
                                                            "--",
                                                        identifier:
                                                            "Speed\n(m/s)"),
                                                    ParameterWidget(
                                                        screenWidth:
                                                            widget.screenWidth,
                                                        screenHeight:
                                                            widget.screenHeight,
                                                        numeral: snapshot.data[
                                                                    'wind']
                                                                ['gust'] ??
                                                            "--",
                                                        identifier:
                                                            "Gust\n(m/s)"),
                                                    ParameterWidget(
                                                        screenWidth:
                                                            widget.screenWidth,
                                                        screenHeight:
                                                            widget.screenHeight,
                                                        numeral: snapshot.data[
                                                                    'wind']
                                                                ['deg'] ??
                                                            "--",
                                                        identifier:
                                                            "Degree\n( ° )"),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: widget.screenWidth / 12,
                                              ),
                                              SizedBox(
                                                width: widget.screenWidth,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    MeridianWidget(
                                                        screenWidth:
                                                            widget.screenWidth,
                                                        iconName: "Sunrise",
                                                        time: DateFormat(
                                                                "hh:mm a")
                                                            .format(DateTime.fromMillisecondsSinceEpoch(
                                                                snapshot.data['sys']
                                                                            [
                                                                            'sunrise'] *
                                                                        1000 +
                                                                    snapshot.data[
                                                                            'timezone'] *
                                                                        1000))),
                                                    const SizedBox(
                                                      width: 20.0,
                                                    ),
                                                    Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: widget
                                                                  .screenWidth /
                                                              8,
                                                          child: Text(
                                                            "${snapshot.data['main']['humidity'] ?? "--"}%",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: 24,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: widget
                                                                  .screenWidth /
                                                              8,
                                                          child: FittedBox(
                                                            child: Text(
                                                              "Humidity",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
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
                                                      screenWidth:
                                                          widget.screenWidth,
                                                      iconName: "Sunset",
                                                      time: DateFormat(
                                                              "hh:mm a")
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                        snapshot.data['sys']
                                                                ['sunset'] *
                                                            1000,
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: widget.screenHeight / 7,
                                                width: widget.screenWidth,
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (snapshot.data['cod'] == 404) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                "Assets/SvgAssets/404-Dark.svg",
                                                width: widget.screenWidth / 2.5,
                                                height:
                                                    widget.screenWidth / 2.5,
                                              ),
                                              SizedBox(
                                                height:
                                                    widget.screenHeight / 20,
                                              ),
                                              Text(
                                                "We couldn't find what you\n were asking for!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (snapshot.data['cod'] == 401) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                "Assets/SvgAssets/APIKey_Error-Dark.svg",
                                                width: widget.screenWidth / 2.5,
                                                height:
                                                    widget.screenWidth / 2.5,
                                              ),
                                              SizedBox(
                                                height:
                                                    widget.screenHeight / 20,
                                              ),
                                              Text(
                                                "Make sure you have a correct API key!\nGo to Settings page and add it!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                "Assets/SvgAssets/404-Dark.svg",
                                                width: widget.screenWidth / 2.5,
                                                height:
                                                    widget.screenWidth / 2.5,
                                              ),
                                              SizedBox(
                                                height:
                                                    widget.screenHeight / 20,
                                              ),
                                              Text(
                                                "We couldn't find what you\n were asking for!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    } else {
                                      return Center(
                                        child: spinkit.SpinKitChasingDots(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      );
                                    }
                                  });
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    (Theme.of(context).primaryColor ==
                                            MaterialColor(
                                                0xFFEFF1F3, lightColor))
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
                                          color: Theme.of(context).hintColor,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              );
                            }
                          });
                    }),
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: widget.screenHeight / 7,
                        decoration: BoxDecoration(
                          gradient: (Theme.of(context).primaryColor ==
                                  MaterialColor(0xFF00272B, darkColor))
                              ? const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                      Color.fromRGBO(255, 255, 255, 0.0),
                                      Color.fromRGBO(255, 255, 255, 0.7),
                                      Color.fromRGBO(255, 255, 255, 1)
                                    ])
                              : const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                      Color.fromRGBO(0, 0, 0, 0.0),
                                      Color.fromRGBO(0, 0, 0, 0.7),
                                      Color.fromRGBO(0, 0, 0, 1)
                                    ]),
                        ),
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: ListWheelScrollView(
                            itemExtent: widget.screenWidth / 5,
                            physics: physics,
                            controller: scrollController,
                            onSelectedItemChanged: (x) {
                              setState(() {
                                selected = x;
                                print("selected: $selected");
                                name = (box.getAt(x) as SavedList).countryName;
                                print("name: $name");
                                selectedCountry = countriesIso[name]!;
                                print("selectedName: $selectedCountry");
                                selectedCity =
                                    (box.getAt(x) as SavedList).cityName;
                                print(selectedCity);
                              });
                            },
                            children: List.generate(
                              box.length,
                              (index) {
                                return AnimatedContainerBuilder(
                                    index, box as Box<SavedList>);
                              },
                              growable: false,
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SvgPicture.asset(
                    "Assets/SvgAssets/List_edit.svg",
                    width: widget.screenWidth / 3,
                    height: widget.screenWidth / 3,
                    color: Theme.of(context).hintColor,
                  ),
                  Text(
                    "Click on this top-right icon & check \n if you have any locations saved",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
