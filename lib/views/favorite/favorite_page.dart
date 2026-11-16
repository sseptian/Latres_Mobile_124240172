import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/tv_show_model.dart';
import '../detail/show_detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Daftar Favorit',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        final list = favoriteController.favorites;

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 64,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Belum ada show favorit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tekan tombol hati pada detail film untuk menambahkan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          itemCount: list.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final show = list[index];
            return _buildFavoriteItem(context, show, favoriteController);
          },
        );
      }),
    );
  }

  Widget _buildFavoriteItem(
    BuildContext context,
    TvShowModel show,
    FavoriteController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF26262C)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        onTap: () {
          Get.to(() => ShowDetailPage(showId: show.id, initialShow: show));
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 48,
            height: 64,
            color: const Color(0xFF26262C),
            child: show.imageUrl != null
                ? Image.network(
                    show.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.grey, size: 24),
                  )
                : const Icon(Icons.movie, color: Colors.grey, size: 24),
          ),
        ),
        title: Text(
          show.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFBBF24),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                show.rating != null ? show.rating!.toStringAsFixed(1) : 'N/A',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFEF4444),
          ),
          tooltip: 'Hapus dari Favorit',
          onPressed: () {
            _showDeleteConfirmation(context, show, controller);
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    TvShowModel show,
    FavoriteController controller,
  ) {
    Get.defaultDialog(
      title: 'Hapus Favorit?',
      titleStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      backgroundColor: const Color(0xFF1E1E22),
      middleText: 'Yakin ingin menghapus "${show.name}" dari daftar favorit?',
      middleTextStyle: TextStyle(color: Colors.grey.shade300, fontSize: 14),
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.grey.shade400,
      buttonColor: const Color(0xFFE50914),
      onConfirm: () {
        Get.back();
        controller.removeFavorite(show.id, show.name);
      },
    );
  }
}
