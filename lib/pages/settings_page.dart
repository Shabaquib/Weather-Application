import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {Key? key,
      required this.snapshot,
      required this.screenWidth,
      required this.screenHeight})
      : super(key: key);
  final snapshot;
  final double screenWidth;
  final double screenHeight;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _controller = TextEditingController();

  String getAPIKey(SharedPreferences arg) {
    return arg.getString('APIKey') ?? "Add API key here";
  }

  setAPIKey(SharedPreferences arg, String key) {
    arg.setString('APIKey', key);
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = (getAPIKey(widget.snapshot) == "Add API key here")
        ? ""
        : getAPIKey(widget.snapshot);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _controller,
                  cursorColor: Theme.of(context).primaryColor,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: getAPIKey(widget.snapshot),
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          style: BorderStyle.solid),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setAPIKey(widget.snapshot, _controller.text);
                  print(_controller.text);
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: (getAPIKey(widget.snapshot) != "Add API key here")
                        ? Colors.amber[200]
                        : Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (getAPIKey(widget.snapshot) != "Add API key here")
                            ? "Saved"
                            : "Save Key",
                        // "Save key",
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Icon(
                        (getAPIKey(widget.snapshot) != "Add API key here")
                            ? Icons.done_all_rounded
                            : Icons.arrow_forward,
                        color: Theme.of(context).primaryColorDark,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.only(bottom: 5.0, left: 10.0),
            child: Text(
              "Credits",
              style: TextStyle(
                  fontSize: 20.0, color: Theme.of(context).primaryColor),
            ),
          ),
          const Divider(
            indent: 10.0,
            endIndent: 30.0,
            thickness: 1.0,
          ),
          const ParameterTiles(
              title: "Pexels",
              subtitle: "The best free stock photos.",
              iconLabel: 'Assets/SvgAssets/pexels.svg',
              ifTrailing: false),
          const ParameterTiles(
              title: "Iconify",
              subtitle: "Free Icons for your peoject",
              iconLabel: 'Assets/SvgAssets/iconify.svg',
              ifTrailing: false),
          const ParameterTiles(
              title: "OpenWeatherMap",
              subtitle: "Free API to get weather Data.",
              iconLabel: 'Assets/SvgAssets/weather.svg',
              ifTrailing: false),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 20.0,
                foregroundImage: AssetImage('Assets/ImageAssets/credit2.png'),
              ),
              title: Text(
                "Undraw",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Free iIllustrations for your projects",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w200),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.only(bottom: 5.0, left: 10.0),
            child: Text(
              "About The Dev",
              style: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const Divider(
            indent: 10.0,
            endIndent: 30.0,
            thickness: 1.0,
          ),
          const SizedBox(
            height: 15.0,
          ),
          const ParameterTiles(
              title: "LinkedIn",
              subtitle: "linkedin.com/in/aquib-raushan-b5b59118a/",
              iconLabel: 'Assets/SvgAssets/linkedIn.svg',
              ifTrailing: true,
              clipData: "https://www.linkedin.com/in/aquib-raushan-b5b59118a/"),
          const ParameterTiles(
              title: "Mail",
              subtitle: "abrokedesigner@yahoo.com",
              iconLabel: 'Assets/SvgAssets/mail.svg',
              ifTrailing: true,
              clipData: "abrokedesigner@yahoo.com"),
          const ParameterTiles(
              title: "Figma",
              subtitle: "@ashley3",
              iconLabel: 'Assets/SvgAssets/figma.svg',
              ifTrailing: true,
              clipData: "https://www.figma.com/@ashley3"),
          const ParameterTiles(
              title: "Behance",
              subtitle: "https://www.behance.net/ahsanaquib",
              iconLabel: 'Assets/SvgAssets/behance.svg',
              ifTrailing: true,
              clipData: "https://www.behance.net/ahsanaquib"),
          Container(
            width: widget.screenWidth * 0.95,
            // child: FittedBox(
            //   child: Text(""), //add some of yours here!
            // ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class ParameterTiles extends StatefulWidget {
  const ParameterTiles(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.iconLabel,
      required this.ifTrailing,
      this.clipData = ""})
      : super(key: key);
  final String title;
  final String subtitle;
  final String iconLabel;
  final bool ifTrailing;
  final String clipData;

  @override
  State<ParameterTiles> createState() => _ParameterTilesState();
}

class _ParameterTilesState extends State<ParameterTiles> {
  copyData(arg) async {
    await Clipboard.setData(ClipboardData(text: arg));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: SvgPicture.asset(
          widget.iconLabel,
          color: Theme.of(context).primaryColor,
          width: 40.0,
          height: 40.0,
        ),
        // tileColor: Colors.amber,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          widget.subtitle,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w200),
        ),
        trailing: (widget.ifTrailing)
            ? GestureDetector(
                onTap: () {
                  copyData(
                      "https://www.linkedin.com/in/aquib-raushan-b5b59118a/");
                  showToast("Copied ${widget.title}",
                      context: context,
                      animation: StyledToastAnimation.scale,
                      position: StyledToastPosition.center,
                      animDuration: const Duration(milliseconds: 200),
                      curve: Curves.decelerate);
                },
                child: const Icon(Icons.copy),
              )
            : Icon(
                Icons.copy,
                color: Theme.of(context).primaryColorDark,
              ),
      ),
    );
  }
}
