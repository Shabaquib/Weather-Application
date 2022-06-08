import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:weather/data/countries_data.dart';

import '../storage/save_data.dart';

class StickyHeaderItem extends StatefulWidget {
  StickyHeaderItem(
      {Key? key,
      required this.screenWidth,
      required this.screenHeight,
      required this.labelCountry,
      required this.labelCities,
      required this.storeBox,
      required this.savedCities})
      : super(key: key);
  final double screenWidth;
  final double screenHeight;
  final String labelCountry;
  final List<dynamic> labelCities;
  Box<SavedList> storeBox;
  final List<String> savedCities;

  @override
  State<StickyHeaderItem> createState() => _StickyHeaderItemState();
}

class _StickyHeaderItemState extends State<StickyHeaderItem> {
  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        leading: SvgPicture.asset(
          "Assets/FlagAssets/${widget.labelCountry}.svg",
          width: 35.0,
          height: 35.0,
        ),
        textColor: Colors.black,
        title: Text(widget.labelCountry),
        tileColor: Colors.teal,
      ),
      content: SizedBox(
        height: widget.screenHeight / 2.5,
        child: ListView.builder(
            itemCount: widget.labelCities.toList().length,
            itemBuilder: (context, index) {
              print("im making content");
              return ListTile(
                title: Text(
                  widget.labelCities[index],
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.0),
                ),
                trailing: AddWidget(
                  country: widget.labelCountry,
                  city: widget.labelCities[index],
                  flag: "Assets/FlagAssets/${widget.labelCountry}.svg",
                  isSaved:
                      (widget.savedCities.contains(widget.labelCities[index])),
                  boxArg: widget.storeBox,
                ),
              );
            }),
      ),
    );
  }
}

class AddWidget extends StatefulWidget {
  AddWidget(
      {Key? key,
      required this.country,
      required this.city,
      required this.flag,
      required this.isSaved,
      required this.boxArg})
      : super(key: key);
  final String country;
  final String city;
  final String flag;
  final bool isSaved;
  Box<SavedList> boxArg;

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  var selected = false;

  citySaved(SavedList arg) {
    print("Save mech invoked");
    if (!(widget.isSaved)) {
      print("Saving");
      widget.boxArg.add(arg);
      setState(() {
        label.value =
            "${(widget.boxArg.getAt(0) as SavedList).countryName},${(widget.boxArg.getAt(0) as SavedList).cityName}";
        selected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (selected || widget.isSaved)
        ? Icon(
            Icons.check,
            color: Theme.of(context).primaryColor,
          )
        : IconButton(
            onPressed: () {
              if (!(widget.isSaved)) {
                var data = SavedList(
                    cityName: widget.city,
                    countryName: widget.country,
                    flagPath: widget.flag);
                showToast("Added ${widget.city}",
                    context: context,
                    animation: StyledToastAnimation.scale,
                    position: StyledToastPosition.center,
                    animDuration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate);
                citySaved(data);
              }
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ));
  }
}
