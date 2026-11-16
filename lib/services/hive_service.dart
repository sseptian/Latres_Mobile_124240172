import 'package:hive_flutter/hive_flutter.dart';
import '../models/tv_show_model.dart';

class HiveService {
  static const String boxName = 'favorites_box';

  static Box get box => Hive.box(boxName);

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static List<TvShowModel> getFavorites() {
    final list = <TvShowModel>[];
    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        if (data is Map) {
          list.add(TvShowModel.fromJson(Map<String, dynamic>.from(data)));
        }
      }
    }
    return list;
  }

  static bool isFavorite(int id) {
    return box.containsKey(id.toString());
  }

  static Future<void> addFavorite(TvShowModel show) async {
    await box.put(show.id.toString(), show.toJson());
  }

  static Future<void> removeFavorite(int id) async {
    await box.delete(id.toString());
  }

  static Future<bool> toggleFavorite(TvShowModel show) async {
    final key = show.id.toString();
    if (box.containsKey(key)) {
      await box.delete(key);
      return false; // Sekarang bukan favorit
    } else {
      await box.put(key, show.toJson());
      return true; // Sekarang favorit
    }
  }
}
