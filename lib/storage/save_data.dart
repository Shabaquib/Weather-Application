import 'package:hive/hive.dart';

part 'save_data.g.dart';

@HiveType(typeId: 1)
class SavedList {
  SavedList({
    required this.cityName,
    required this.countryName,
    required this.flagPath,
  });

  @HiveField(0)
  String cityName;

  @HiveField(1)
  String countryName;

  @HiveField(2)
  String flagPath;
}
