import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/tv_show_model.dart';
import '../services/hive_service.dart';

class FavoriteController extends GetxController {
  final RxList<TvShowModel> favorites = <TvShowModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    favorites.assignAll(HiveService.getFavorites());
  }

  bool isFavorite(int id) {
    return favorites.any((show) => show.id == id);
  }

  Future<void> toggleFavorite(TvShowModel show) async {
    final currentlyFav = isFavorite(show.id);
    if (currentlyFav) {
      await HiveService.removeFavorite(show.id);
      favorites.removeWhere((item) => item.id == show.id);
      Get.snackbar(
        'Dihapus dari Favorit',
        '${show.name} dihapus dari daftar favorit.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF374151),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        icon: const Icon(Icons.favorite_border, color: Colors.white70),
      );
    } else {
      await HiveService.addFavorite(show);
      favorites.add(show);
      Get.snackbar(
        'Ditambahkan ke Favorit',
        '${show.name} berhasil disimpan ke daftar favorit.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE50914),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        icon: const Icon(Icons.favorite, color: Colors.white),
      );
    }
  }

  Future<void> removeFavorite(int id, String name) async {
    await HiveService.removeFavorite(id);
    favorites.removeWhere((item) => item.id == id);
    Get.snackbar(
      'Dihapus',
      '$name telah dihapus dari favorit.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF374151),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.delete_outline, color: Colors.white70),
    );
  }
}
