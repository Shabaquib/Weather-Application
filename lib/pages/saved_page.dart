import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'search_page.dart';

import '../storage/save_data.dart';

class SavedPage extends StatefulWidget {
  SavedPage(
      {Key? key,
      required this.screenHeight,
      required this.screenWidth,
      required this.boxSnap})
      : super(key: key);
  final double screenWidth;
  final double screenHeight;
  Box<SavedList> boxSnap;

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Text("Saved"),
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SearchPage(
                        screenHeight: widget.screenHeight,
                        screenWidth: widget.screenWidth,
                        box: widget.boxSnap),
                  ),
                ),
                icon: const Icon(
                  Icons.manage_search_sharp,
                  size: 30.0,
                ),
              ),
            ),
          ],
          elevation: 2.0),
      body: WatchBoxBuilder(
          box: widget.boxSnap,
          builder: (context, box) {
            if (box.length > 0) {
              return ListView.separated(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  print(
                      "  ${(box.getAt(index) as SavedList).cityName}, ${(box.getAt(index) as SavedList).countryName}, ${(box.getAt(index) as SavedList).flagPath}  ");
                  return ListTile(
                    leading: SvgPicture.asset(
                      (box.getAt(index) as SavedList).flagPath,
                      // "Assets/FlagAssets/${titleList[index].toLowerCase()}.svg",
                      width: 40.0,
                      height: 40.0,
                    ),
                    title: Text(
                      (box.getAt(index) as SavedList).cityName,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text(
                      (box.getAt(index) as SavedList).countryName,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          box.deleteAt(index);
                        },
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).primaryColor)),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1.0,
                    indent: 20.0,
                    endIndent: 20.0,
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.manage_search_sharp,
                      size: widget.screenWidth / 2.5,
                      color: Theme.of(context).hintColor,
                    ),
                    Text(
                      "Click on this top-right icon \n to add locations",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
