import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

import '../data/countries_data.dart';
import '../storage/save_data.dart';
import '../widgets/sticky_header.dart';

var countries = countriesIso.values.toList();

class SearchPage extends StatefulWidget {
  SearchPage(
      {Key? key,
      required this.screenHeight,
      required this.screenWidth,
      required this.box})
      : super(key: key);
  final double screenWidth;
  final double screenHeight;
  Box<SavedList> box;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchterm = "";
  List returner = [];
  List<String> allSaved = [];

  checkList(Box<SavedList> arg) {
    if (arg.length > 0) {
      for (var i = 0; i < arg.length; i++) {
        allSaved.add(arg.getAt(i)!.cityName);
      }
    }
  }

  Future<Map<String, dynamic>> readJson() async {
    final String response =
        await rootBundle.loadString('Assets/countries.json');
    final data = await json.decode(response);
    return data;
  }

  countriesSelected(String searchTerm) {
    if (searchTerm.isNotEmpty) {
      returner = countriesIso.keys
          .toList()
          .where((element) =>
              element.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    } else {
      returner = [];
    }
    print(returner);
  }

  savedCities(Box box) {
    for (var i = 0; i < box.length; i++) {
      allSaved.add((box.getAt(i) as SavedList).cityName);
    }
  }

  @override
  Widget build(BuildContext context) {
    savedCities(widget.box);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: (value) {
            searchterm = value;
            setState(() {
              countriesSelected(searchterm);
            });
          },
          cursorColor: Theme.of(context).primaryColor,
          style: TextStyle(color: Theme.of(context).primaryColor),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: "Search Countries",
            hintStyle: TextStyle(
              color: Theme.of(context).hintColor,
            ),
            labelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        elevation: 2.0
      ),
      body: FutureBuilder(
          future: readJson(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (searchterm.isNotEmpty) {
                if (returner.isNotEmpty) {
                  return ListView.builder(
                      itemCount: returner.length,
                      itemBuilder: (context, index) {
                        return StickyHeaderItem(
                          screenWidth: widget.screenWidth,
                          screenHeight: widget.screenHeight,
                          labelCountry: returner[index],
                          labelCities: snapshot.data![returner[index]].toList(),
                          storeBox: widget.box,
                          savedCities: allSaved,
                        );
                      });
                } else {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "Assets/SvgAssets/search_page_dark.svg",
                          width: widget.screenWidth / 1.5,
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: const Text(
                            "You Searched?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.manage_search_sharp,
                        size: widget.screenWidth / 3,
                        color: Theme.of(context).hintColor,
                      ),
                      Text(
                        "Type in the textfield above \n to search coutries!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.manage_search_sharp,
                      size: widget.screenWidth / 3,
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
