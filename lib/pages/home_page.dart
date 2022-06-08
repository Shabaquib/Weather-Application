import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import 'package:weather/pages/geolocator.dart';
import 'settings_page.dart';
import 'home_content_widget.dart';
import 'package:weather/data/countries_data.dart';
import 'saved_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.snapshots}) : super(key: key);
  final List<dynamic> snapshots;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isVisible = false;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connecitvity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    } else {
      return _updateConnectionStatus(result);
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
    connectionStatus(_connectionStatus);
    print(_connectionStatus.toString());
  }

  connectionStatus(arg) {
    if (arg == ConnectivityResult.mobile || arg == ConnectivityResult.wifi) {
      repeater.value = false;
    } else {
      repeater.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SettingsPage(
                    snapshot: widget.snapshots[2],
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                )),
            icon: const Icon(Icons.settings_outlined)),
        // leading: const Icon(Icons.settings_outlined),
        title: const Text("Weather"),
        actions: <Widget>[
          const ConnectionWarnWidget(),
          Container(
            margin: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GeoLocatorPage(
                      apiKey: widget.snapshots[2].getString('APIKey') ?? "",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight),
                ),
              ),
              icon: Icon(
                Icons.explore_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SavedPage(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    boxSnap: widget.snapshots[1],
                  ),
                ),
              ),
              icon: SvgPicture.asset(
                "Assets/SvgAssets/List_edit.svg",
                width: 30.0,
                height: 30.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
        // elevation: 0.0,
      ),
      body: HomePageWidget(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        dirPath: widget.snapshots[0],
        box: widget.snapshots[1],
        apiKey: widget.snapshots[2].getString('APIKey') ?? "",
      ),
    );
  }

  @override
  void dispose() async {
    await Hive.box('listBox').close();
    _connectivitySubscription.cancel();
    super.dispose();
  }
}

class ConnectionWarnWidget extends StatefulWidget {
  const ConnectionWarnWidget({Key? key}) : super(key: key);

  @override
  State<ConnectionWarnWidget> createState() => _ConnectionWarnWidgetState();
}

class _ConnectionWarnWidgetState extends State<ConnectionWarnWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: repeater,
        builder: (a, b, c) {
          if (b) {
            return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: const [
                        Icon(
                          Icons.error,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("No Connection detected!"),
                      ],
                    ),
                    backgroundColor: Colors.red.shade300,
                    padding: const EdgeInsets.all(25.0),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber.shade600,
                  ),
                ));
          } else {
            return const Opacity(
                opacity: 0.0, child: Icon(Icons.warning_amber_rounded));
          }
        });
  }
}
