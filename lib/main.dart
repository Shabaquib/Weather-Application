import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'storage/save_data.dart';
import 'themeData.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SavedListAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Weather',
      theme: themeLight,
      darkTheme: themeDark,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<String> returnDirPath() {
    return path_provider.getTemporaryDirectory().then((value) {
      return value.path;
    });
  }

  Future<Box<SavedList>> returnBoxOpen() {
    return Hive.openBox('listBox');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          returnDirPath(),
          returnBoxOpen(),
          SharedPreferences.getInstance()
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (Theme.of(context).primaryColor ==
                            MaterialColor(0xFFEFF1F3, lightColor))
                        ? SvgPicture.asset(
                            "Assets/SvgAssets/Splash-Dark.svg",
                            width: 200,
                            height: 200,
                          )
                        : SvgPicture.asset(
                            "Assets/SvgAssets/Splash-Light.svg",
                            width: 200,
                            height: 200,
                          ),
                    Text(
                      "Welcome",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 40.0),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (_) => MyHomePage(
                                        snapshots: snapshot.data!,
                                      ))),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).primaryColorDark,
                          )),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: SvgPicture.asset(
                  "Assets/SvgAssets/Welcome_dark.svg",
                  width: 200,
                  height: 200,
                ),
              ),
            );
          }
        });
  }
}
